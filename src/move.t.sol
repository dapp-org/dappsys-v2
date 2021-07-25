// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

import {DSTest} from "ds-test/test.sol";
import {ERC20} from "weird-erc20/ERC20.sol";
import {ReturnsFalseToken} from "weird-erc20/ReturnsFalse.sol";
import {MissingReturnsToken} from "weird-erc20/MissingReturns.sol";

import {Hevm} from "./hevm.sol";
import {Move} from "../auth.sol";

contract TestMove is DSTest, Move {
    ReturnsFalseToken returnsFalse = new ReturnsFalseToken(type(uint).max);
    MissingReturnsToken missingReturns = new MissingReturnsToken(type(uint).max);
    ERC20 erc20 = new ERC20(type(uint).max);

    function proveWithMissingReturns(address dst, uint amt) {
        if (dst == address(this)) return;

        assertEq(missingReturns.balanceOf(dst), 0);
        move(address(missingReturns), dst, amt);
        assertEq(missingReturns.balanceOf(dst), amt);
    }

    // --- utils ---

    function approve(address token, address src, address dst, uint amt) internal {
        hevm.store(
            address(token),
            keccak256(abi.encode(dst, keccak256(abi.encode(src, uint256(3))))),
            bytes32(uint(amt))
        );
        assertEq(ERC20(token).allowance(src, dst), amt, "wrong allowance");
    }
}
