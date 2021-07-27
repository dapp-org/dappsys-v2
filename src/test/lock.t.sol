// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

import {Lock} from "../lock.sol";

/*
    This contract uses the solc SMTChecker to verify that there does not exist
    a reentrant call from `enter` that could set `broken` to true
*/

interface External {
  function ext(bytes calldata data) external;
}

contract TestLock is Lock {
    bool broken = false;
    bool entered = false;

    function enter(address usr, bytes calldata data) external lock {
        entered = true;
        External(usr).ext(data);
        entered = false;
    }

    function dobreak() external lock {
        require(entered);
        broken = true;
    }

    function invariant() view external {
        assert(!broken);
    }
}
