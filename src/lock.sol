// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

contract Lock {
    bool unlocked = true;

    modifier lock() {
        require(unlocked, "lock/locked");
        unlocked = false;
        _;
        unlocked = true;
    }
}

