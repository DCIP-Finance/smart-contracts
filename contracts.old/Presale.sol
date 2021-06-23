// SPDX-License-Identifier: MIT

pragma solidity >=0.6.8;

import {SafeMath} from "./library/SafeMath.sol";
import {Context} from "./Context.sol";
import {DCIP} from "./interface/DCIP.sol";
import {Ownable} from "./Ownable.sol";
import {IBEP20} from "./interface/IBEP20.sol";

/// @title PrivateSaleDCIP Contract

contract PrivateSaleDCIP is Ownable {
    using SafeMath for uint256;

    DCIP public token;
    address payable public presale;
    uint256 public presaleStartTimestamp;
    uint256 public presaleEndTimestamp;
    uint256 public hardCapEthAmount = 250 ether;
    uint256 public totalDepositedEthBalance;
    uint256 public minimumDepositEthAmount = 0 ether;
    uint256 public maximumDepositEthAmount = 30 ether;
    uint256 public tokenPerBNB = 750000000000;

    mapping(address => uint256) public deposits;
    mapping(address => uint256) public withdraws;
    mapping(address => bool) public whitelist;

    constructor(DCIP _token) public {
        token = _token;
        presale = 0xdA9f9d44F4c5022c789641802c10Da5992557D35; //private wallet

        presaleStartTimestamp = now;
        presaleEndTimestamp = now.add(1 days);
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        require(
            now >= presaleStartTimestamp && now <= presaleEndTimestamp,
            "presale is not active"
        );
        require(
            totalDepositedEthBalance.add(msg.value) <= hardCapEthAmount,
            "deposit limits reached"
        );
        require(
            deposits[msg.sender].add(msg.value) >= minimumDepositEthAmount &&
                deposits[msg.sender].add(msg.value) <= maximumDepositEthAmount,
            "incorrect amount"
        );

        totalDepositedEthBalance = totalDepositedEthBalance.add(msg.value);
        deposits[msg.sender] = deposits[msg.sender].add(msg.value);
        emit Deposited(msg.sender, msg.value);
    }

    function withdraw() public payable {
        require(
            now >= presaleStartTimestamp && now <= presaleEndTimestamp,
            "presale is not active"
        );
        require(deposits[msg.sender] > 0, "invalid deposit amount");
        require(whitelist[msg.sender] == true, "invalid withdraw address");

        uint256 tokenAmount = getCalculatedAmount(msg.sender);
        require(tokenAmount > 0, "invalid token amount");
        token.transfer(msg.sender, tokenAmount);
        withdraws[msg.sender] = withdraws[msg.sender].add(tokenAmount);
    }

    function getCalculatedAmount(address _address)
        public
        view
        returns (uint256)
    {
        uint256 totalAmount = deposits[_address] * tokenPerBNB;
        uint256 reward =
            token
                .balanceOf(address(this))
                .mul(deposits[_address])
                .div(totalDepositedEthBalance)
                .div(5);
        if (
            now > presaleEndTimestamp.add(2 days) && withdraws[msg.sender] == 0
        ) {
            return totalAmount.div(5).add(reward);
        } else if (
            now > presaleEndTimestamp.add(32 days) &&
            withdraws[msg.sender] == totalAmount.div(5)
        ) {
            return totalAmount.div(5).add(reward);
        } else if (
            now > presaleEndTimestamp.add(62 days) &&
            withdraws[msg.sender] == totalAmount.div(5).mul(2)
        ) {
            return totalAmount.div(5).add(reward);
        } else if (
            now > presaleEndTimestamp.add(92 days) &&
            withdraws[msg.sender] == totalAmount.div(5).mul(3)
        ) {
            return totalAmount.div(5).add(reward);
        } else if (
            now > presaleEndTimestamp.add(122 days) &&
            withdraws[msg.sender] == totalAmount.div(5).mul(4)
        ) {
            return totalAmount.div(5).add(reward);
        }
        return 0;
    }

    function releaseFunds() external onlyOwner {
        msg.sender.transfer(address(this).balance);
    }

    function setPresale(address payable presaleAdress) external onlyOwner {
        presale = presaleAdress;
    }

    function addWhiteList(address payable _address) external onlyOwner {
        whitelist[_address] = true;
    }

    function removeWhiteList(address payable _address) external onlyOwner {
        whitelist[_address] = false;
    }

    function recoverBEP20(address tokenAddress, uint256 tokenAmount)
        external
        onlyOwner
    {
        IBEP20(tokenAddress).transfer(this.owner(), tokenAmount);
        emit Recovered(tokenAddress, tokenAmount);
    }

    function getDepositAmount() public view returns (uint256) {
        return totalDepositedEthBalance;
    }

    function getLeftTimeAmount() public view returns (uint256) {
        if (now > presaleEndTimestamp) {
            return 0;
        } else {
            return (presaleEndTimestamp - now);
        }
    }

    event Deposited(address indexed user, uint256 amount);
    event Recovered(address token, uint256 amount);
}
