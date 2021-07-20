// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.4;

interface Hevm {
    function warp(uint256) external;
    function roll(uint256) external;
    function store(address,bytes32,bytes32) external;
    function sign(uint,bytes32) external returns (uint8,bytes32,bytes32);
    function addr(uint) external returns (address);
    function ffi(string[] calldata) external returns (bytes memory);
}