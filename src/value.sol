// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;
import {Auth} from "./auth.sol";

contract Value is Auth {

    // --- data ---

    bool    public has;
    bytes32 public val;

    // --- logs ---

    event Poke(bytes32 val);
    event Void();

    // --- init ---

    constructor() Auth(msg.sender) {}

    // --- value ---

    function peek() external view returns (bytes32, bool) {
        return (val,has);
    }

    function read() external view returns (bytes32) {
        require(has, "value/empty-value");
        return val;
    }

    function poke(bytes32 wut) external auth {
        val = wut;
        has = true;
        emit Poke(wut);
    }

    function void() external auth {
        has = false;
        emit Void();
    }
}
