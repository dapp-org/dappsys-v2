// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.4;

import {Auth} from "./auth.sol";

contract Delay is Auth {

    // --- data ---

    mapping (bytes32 => bool) public plans;
    uint public delay;

    // --- logs ---

    event File(uint delay);
    event Plot(address usr, bytes data, uint eta);
    event Drop(address usr, bytes data, uint eta);
    event Exec(address usr, bytes data, uint eta);

    // --- init ---

    constructor(uint delay_)
        Auth(msg.sender)
    {
        delay = delay_;
        emit File(delay_);
    }

    // --- admin ---

    function file(uint delay_) public {
        require(msg.sender == address(this), "delay/undelayed-file");
        delay = delay_;
        emit File(delay_);
    }

    // --- delay ---

    function plot(address usr, bytes calldata data, uint eta) external auth {
        require(eta >= block.timestamp + delay, "delay/delay-not-respected");
        plans[keccak256(abi.encode(usr, data, eta))] = true;
        emit Plot(usr, data, eta);
    }

    function drop(address usr, bytes calldata data, uint eta) external auth {
        plans[keccak256(abi.encode(usr, data, eta))] = false;
        emit Drop(usr, data, eta);
    }

    function exec(address usr, bytes calldata data, uint eta) external returns (bytes memory out) {
        bytes32 hash = keccak256(abi.encode(usr, data, eta));

        require(plans[hash],            "delay/unscheduled-plan");
        require(block.timestamp >= eta, "delay/premature-exec");

        plans[hash] = false;

        bool ok;
        (ok, out) = usr.delegatecall(data);
        require(ok, "delay/delegatecall-error");

        emit Exec(usr, data, eta);
    }
}
