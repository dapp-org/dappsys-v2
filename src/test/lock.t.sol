// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;
pragma experimental SMTChecker;

import {DSTest} from "ds-test/test.sol";
import {Hevm} from "./hevm.sol";
import {Lock} from "../lock.sol";

/*
    This contract uses the solc SMTChecker to verify that there does not exist
    a reentrant call from `enter` that could set `broken` to true
*/
contract TestLock is Lock {
    bool broken = false;
    bool entered = false;

    function enter(address usr, bytes calldata data) external lock {
        entered = true;
        (bool res, ) = usr.call(data);
        entered = false;
    }

    function dobreak() external lock {
        require(entered);
        broken = true;
    }

    function invariant() external {
        assert(!broken);
    }
}
