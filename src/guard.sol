// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

import {Auth} from "./auth.sol";

contract Guard is Auth {
    mapping (address => mapping (address => mapping (bytes4 => bool))) public acl;

    event Permit(address src, address dst, string sig);
    event Forbid(address src, address dst, string sig);

    constructor() Auth(msg.sender) {}

    function permit(address src, address dst, string calldata sig) auth external {
        bytes4 selector = bytes4(keccak256(bytes(sig)));
        acl[src][dst][selector] = true;
        emit Permit(src, dst, sig);
    }

    function forbid(address src, address dst, string calldata sig) auth external {
        bytes4 selector = bytes4(keccak256(bytes(sig)));
        acl[src][dst][selector] = false;
        emit Forbid(src, dst, sig);
    }
}

contract Guarded {
    Guard immutable guard;
    constructor(address _guard) {
        guard = Guard(_guard);
    }

    modifier guarded() {
        bytes4 selector = bytes4(msg.data[:4]);
        require(guard.acl(msg.sender, address(this), selector), "guard/unauthorized");
        _;
    }
}
