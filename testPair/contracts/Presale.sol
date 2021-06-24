// SPDX-License-Identifier: MIT

// File: @openzeppelin/contracts/utils/Address.sol

pragma solidity ^0.6.2;

/**
 * @dev Collection of functions related to the address type
 */
library Address {
    /**
     * @dev Returns true if `account` is a contract.
     *
     * [IMPORTANT]
     * ====
     * It is unsafe to assume that an address for which this function returns
     * false is an externally-owned account (EOA) and not a contract.
     *
     * Among othex`rs, `isContract` will return false for the following
     * types of addresses:
     *
     *  - an externally-owned account
     *  - a contract in construction
     *  - an address where a contract will be created
     *  - an address where a contract lived, but was destroyed
     * ====
     */
    function isContract(address account) internal view returns (bool) {
        // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
        // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
        // for accounts without code, i.e. `keccak256('')`
        bytes32 codehash;
        bytes32 accountHash =
            0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
        // solhint-disable-next-line no-inline-assembly
        assembly {
            codehash := extcodehash(account)
        }
        return (codehash != accountHash && codehash != 0x0);
    }

    /**
     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
     * `recipient`, forwarding all available gas and reverting on errors.
     *
     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
     * of certain opcodes, possibly making contracts go over the 2300 gas limit
     * imposed by `transfer`, making them unable to receive funds via
     * `transfer`. {sendValue} removes this limitation.
     *
     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
     *
     * IMPORTANT: because control is transferred to `recipient`, care must be
     * taken to not create reentrancy vulnerabilities. Consider using
     * {ReentrancyGuard} or the
     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
     */
    function sendValue(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }
}

// File: @openzeppelin/contracts/GSN/Context.sol

pragma solidity ^0.6.0;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor() internal {}

    function _msgSender() internal view virtual returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

// File: @openzeppelin/contracts/token/BEP20/IBEP20.sol

pragma solidity ^0.6.0;

/**
 * @dev Interface of the BEP20 standard as defined in the EIP.
 */
interface IBEP20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount)
        external
        returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender)
        external
        view
        returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

// File: @openzeppelin/contracts/math/SafeMath.sol

pragma solidity ^0.6.0;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b <= a, errorMessage);
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(
        uint256 a,
        uint256 b,
        string memory errorMessage
    ) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

// File: @openzeppelin/contracts/access/Ownable.sol

pragma solidity ^0.6.0;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    /**
     * @dev Initializes the contract setting the deployer as the initial owner.
     */
    constructor() internal {
        address msgSender = _msgSender();
        _owner = msgSender;
        emit OwnershipTransferred(address(0), msgSender);
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        require(_owner == _msgSender(), "Ownable: caller is not the owner");
        _;
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        emit OwnershipTransferred(_owner, newOwner);
        _owner = newOwner;
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions anymore. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby removing any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        emit OwnershipTransferred(_owner, address(0));
        _owner = address(0);
    }
}

/// @title PrivateSaleDCIP Contract

pragma solidity ^0.6.0;

interface IDCIP {
    function transfer(address to, uint256 amount) external;

    function balanceOf(address account) external view returns (uint256);

    function decimals() external pure returns (uint8);
}

contract PrivateSaleDCIP is Ownable {
    using SafeMath for uint256;

    IDCIP public token;
    uint256 public presaleStartTimestamp;
    uint256 public presaleEndTimestamp;
    uint256 public hardCapEthAmount = 250 ether;
    uint256 public totalDepositedEthBalance;
    uint256 public minimumDepositEthAmount = 0 ether;
    uint256 public maximumDepositEthAmount = 50 ether;
    uint256 public rate;

    mapping(address => uint256) public deposits;
    mapping(address => uint256) public withdraws;
    mapping(address => bool) public whitelist;

    constructor(IDCIP _token, uint256 _rate) public {
        presaleStartTimestamp = now;
        presaleEndTimestamp = now.add(4 minutes);
        token = _token;
        rate = _rate.mul(10**uint256(token.decimals())).div(10 ^ 18);
    }

    receive() external payable {
        deposit();
    }

    function deposit() public payable {
        require(
            now >= presaleStartTimestamp && now <= presaleEndTimestamp,
            "presale is not active"
        );
        require(whitelist[msg.sender] == true, "invalid deposit address");
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

    function withdraw() public {
        require(deposits[msg.sender] > 0, "invalid deposit amount");
        require(whitelist[msg.sender] == true, "invalid withdraw address");

        uint256 tokenAmount = getCalculatedAmount(msg.sender);
        require(tokenAmount > 0, "invalid token amount");
        token.transfer(msg.sender, tokenAmount);
        withdraws[msg.sender] = withdraws[msg.sender].add(tokenAmount);
        emit Withdrawn(msg.sender, tokenAmount);
    }

    function tokensFromWei(uint256 twei) public view returns (uint256) {
        return twei.div(rate);
    }

    function debugRate() public view returns (uint256) {
        return rate;
    }

    function debugBalanceOfContract() public view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function debugWeiPrt1(uint256 twei) public view returns (uint256) {
        return twei.div(10**18);
    }

    function debugWeiPrt2() public view returns (uint256) {
        return rate.mul(10**uint256(token.decimals()));
    }

    function tokenDecimals() public view returns (uint256) {
        return token.decimals();
    }

    function tokenDecimalsCasted() public view returns (uint256) {
        return uint256(token.decimals());
    }

    function getCalculatedAmount(address _address)
        public
        view
        returns (uint256)
    {
        uint256 totalAmount = tokensFromWei(deposits[_address]);

        if (
            now > presaleEndTimestamp.add(1 minutes) &&
            withdraws[msg.sender] == 0
        ) {
            return totalAmount.div(5);
        } else if (
            now > presaleEndTimestamp.add(2 minutes) &&
            withdraws[msg.sender] == totalAmount.div(5)
        ) {
            return totalAmount.div(5);
        } else if (
            now > presaleEndTimestamp.add(3 minutes) &&
            withdraws[msg.sender] == totalAmount.div(5).mul(2)
        ) {
            return totalAmount.div(5);
        } else if (
            now > presaleEndTimestamp.add(4 minutes) &&
            withdraws[msg.sender] == totalAmount.div(5).mul(3)
        ) {
            return totalAmount.div(5);
        } else if (
            now > presaleEndTimestamp.add(5 minutes) &&
            withdraws[msg.sender] == totalAmount.div(5).mul(4)
        ) {
            return totalAmount.div(5);
        }
        return 0;
    }

    function releaseFunds() external onlyOwner {
        msg.sender.transfer(address(this).balance);
    }

    function addWhiteList(address payable _address) external onlyOwner {
        whitelist[_address] = true;
    }

    function removeWhiteList(address payable _address) external onlyOwner {
        whitelist[_address] = false;
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
    event Withdrawn(address indexed user, uint256 amount);
}

contract PreSaleDCIP is Ownable {
    using SafeMath for uint256;

    mapping(address => uint256) public deposits;
    mapping(address => uint256) public withdraws;
    mapping(address => bool) public whitelist;

    IDCIP public token;
    uint256 public presaleStartTimestamp;
    uint256 public presaleEndTimestamp;
    uint256 public hardCapEthAmount = 250 ether;
    uint256 public totalDepositedEthBalance;
    uint256 public minimumDepositEthAmount = 0 ether;
    uint256 public maximumDepositEthAmount = 50 ether;
    uint256 public rate;

    constructor(IDCIP _token, uint256 _rate) public {
        presaleStartTimestamp = now;
        presaleEndTimestamp = now.add(10 minutes);
        token = _token;
        rate = _rate;
    }

    receive() external payable {
        trade();
    }

    function trade() public payable {
        require(
            now >= presaleStartTimestamp && now <= presaleEndTimestamp,
            "presale is not active"
        );
        require(
            totalDepositedEthBalance.add(msg.value) <= hardCapEthAmount,
            "trade limits reached"
        );
        require(
            deposits[msg.sender].add(msg.value) >= minimumDepositEthAmount &&
                deposits[msg.sender].add(msg.value) <= maximumDepositEthAmount,
            "incorrect amount"
        );

        totalDepositedEthBalance = totalDepositedEthBalance.add(msg.value);
        deposits[msg.sender] = deposits[msg.sender].add(msg.value);
        token.transfer(msg.sender, msg.value / rate);
        emit Traded(msg.sender, msg.value);
    }

    function releaseFunds() external onlyOwner {
        msg.sender.transfer(address(this).balance);
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

    event Traded(address indexed user, uint256 amount);
}
