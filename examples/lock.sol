// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

import {Lock} from "dappsys-v2/lock.sol";

contract Locked is Lock {
    uint public value = 0;

    function badSet(uint v) external lock {
        doSet(v);
    }

    function doBadSet(uint v) internal lock {
        value = v;
    }

    function goodSet(uint v) external lock {
        doGoodSet(v);
    }

    function doGoodSet(uint v) internal {
        value = v;
    }
}

contract Test {
    function go() external {
        Locked locked = new Locked();

        // this call will work since `doGoodSet` is not protected by the lock
        locked.goodSet(10);

        // this will always revert since `unlocked` is `false` during the inner call to `doBadSet`
        locked.badSet(10);
    }
}
