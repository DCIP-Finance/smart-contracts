// SPDX-License-Identifier: Unlicensed

pragma solidity >=0.6.8;

interface DCIP {
    function transfer(address to, uint256 amount) external;

    function balanceOf(address account) external view returns (uint256);
}
