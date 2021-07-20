// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.4;

interface ERC20 {
    function balanceOf(address usr) external view returns (uint256);
    function totalSupply() external view returns (uint256);

    function allowance(address src, address dst) external view returns (uint256);
    function approve(address dst, uint256 amt) external returns (bool);

    function transfer(address dst, uint256 amt) external returns (bool);
    function transferFrom(address src, address dst, uint256 amt) external returns (bool);

    event Transfer(address indexed src, address indexed dst, uint256 amt);
    event Approval(address indexed src, address indexed dst, uint256 amt);
}
