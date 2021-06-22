// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.4;

import {Value} from "./value.sol";
import {DSTest} from "ds-test/test.sol";

contract TestValue is DSTest {
    Value value = new Value();

    function provePoke(bytes32 wut) public {
        assertTrue(!value.has());

        value.poke(wut);

        assertTrue(value.has());
        assertEq(value.read(), wut);
    }

    function proveFailEmptyRead() public {
        assertTrue(!value.has());
        value.read();
    }

    function proveVoid(bytes32 wut) public {
        value.poke(wut);
        value.void();
        assertTrue(!value.has());
    }

    function proveInitialAuth(address usr) public {
        assertTrue(value.wards(address(this)));
        if (usr != address(this)) {
            assertTrue(value.wards(address(this)));
        }
    }
}
