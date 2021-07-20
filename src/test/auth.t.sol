// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {DSTest} from "ds-test/test.sol";
import {Auth} from "../auth.sol";
import {Hevm} from "./hevm.sol";

contract TestAuth is DSTest {
    Auth auth = new Auth();
    Hevm hevm = Hevm(HEVM_ADDRESS);

    // --- tests ---

    function proveFailRelyNonWard(address usr) public {
        if (auth.wards(address(this))) return;
        auth.rely(usr);
    }

    function proveRely(address usr) public {
        if (usr == address(this)) return;
        makeWard(address(this));

        assertTrue(!auth.wards(usr));
        auth.rely(usr);
        assertTrue(auth.wards(usr));
    }

    function proveFailDenyNonWard(address usr) public {
        if (auth.wards(address(this))) return;
        auth.deny(usr);
    }

    function proveDeny(address usr) public {
        if (usr == address(this)) return;
        makeWard(address(this));
        makeWard(usr);

        assertTrue(auth.wards(usr));
        auth.deny(usr);
        assertTrue(!auth.wards(usr));
    }

    // --- utils ---

    function makeWard(address usr) internal {
        hevm.store(
            address(auth),
            keccak256(abi.encode(usr, uint256(0))),
            bytes32(uint(1))
        );
    }
}
