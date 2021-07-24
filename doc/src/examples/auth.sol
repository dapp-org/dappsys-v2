// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

import {Auth} from "dappsys-v2/auth.sol";

contract Set is Auth {
    uint public value;

    // note that we must call the constructor of Auth to specify the initial ward
    constructor(uint v) Auth(msg.sender) {
        value = v;
    }

    function set(uint v) external auth {
        value = v;
    }
}

contract UseSet {
    function go() external {
        Set set = new Set(10);

        // we are a ward here since we deployed the contract
        require(set.wards(address(this)));

        // since we are a ward we can call `set`
        set.set(11);
        require(set.value() == 11);

        // make vitalik a ward
        set.rely(0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B);
        // revoke our authority
        set.deny(address(this));

        // this fails now since we are no longer a ward
        set.set(12);
    }
}
