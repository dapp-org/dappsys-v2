// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

contract Lock {
    uint unlocked = 1;

    modifier lock() {
        require(unlocked, "lock/locked");
        unlocked = 0;
        _;
        unlocked = 1;
    }
}
