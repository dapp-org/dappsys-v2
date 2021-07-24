// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

import {DSTest} from "ds-test/test.sol";
import {Auth} from "../auth.sol";
import {Hevm} from "./hevm.sol";

contract TestAuth is DSTest {
    Hevm hevm = Hevm(HEVM_ADDRESS);

    function proveConstructorWard(address usr) public {
        Auth auth = new Auth(usr);
        assertTrue(auth.wards(usr));
    }

    function proveFailRelyNonWard(address usr) public {
        Auth auth = new Auth(address(0));
        auth.rely(usr);
    }

    function proveRely(address usr) public {
        if (usr == address(this)) return;
        Auth auth = new Auth(address(this));

        assertTrue(!auth.wards(usr));
        auth.rely(usr);
        assertTrue(auth.wards(usr));
    }

    function proveFailDenyNonWard(address usr) public {
        Auth auth = new Auth(address(0));
        auth.deny(usr);
    }

    function proveDeny(address usr) public {
        if (usr == address(this)) return;
        Auth auth = new Auth(address(this));
        auth.rely(usr);

        assertTrue(auth.wards(usr));
        auth.deny(usr);
        assertTrue(!auth.wards(usr));
    }
}
