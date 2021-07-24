// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

contract Auth {
    mapping (address => bool) public wards;

    event Rely(address usr);
    event Deny(address usr);

    constructor(address usr) {
        wards[usr] = true;
        emit Rely(usr);
    }

    modifier auth {
        require(wards[msg.sender], "auth/unauthorized");
        _;
    }

    function rely(address usr) external auth {
        wards[usr] = true;
        emit Rely(usr);
    }

    function deny(address usr) external auth {
        wards[usr] = false;
        emit Deny(usr);
    }
}
