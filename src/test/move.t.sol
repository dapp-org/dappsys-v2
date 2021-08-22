// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

import {DSTest} from "ds-test/test.sol";
import {ERC20} from "weird-erc20/ERC20.sol";
import {ReturnsFalseToken} from "weird-erc20/ReturnsFalse.sol";
import {MissingReturnToken} from "weird-erc20/MissingReturns.sol";
import {TransferFromSelfToken} from "weird-erc20/TransferFromSelf.sol";

import {Hevm} from "./hevm.sol";
import {move} from "../move.sol";

contract TestMove is DSTest {
    ReturnsFalseToken returnsFalse = new ReturnsFalseToken(type(uint).max);
    MissingReturnToken missingReturn = new MissingReturnToken(type(uint).max);
    TransferFromSelfToken transferFromSelf = new TransferFromSelfToken(type(uint).max);
    ERC20 erc20 = new ERC20(type(uint).max);
    Hevm hevm = Hevm(HEVM_ADDRESS);

    // success with missing return value
    function proveWithMissingReturn(address dst, uint amt) public {
        verifyMove(address(missingReturn), dst, amt);
    }
    function proveWithMissingReturn(address src, address dst, uint amt) public {
        verifyMove(address(missingReturn), src, dst, amt);
    }

    // success with OZ style transferFrom self semantics
    function proveWithTransferFromSelf(address dst, uint amt) public {
        verifyMove(address(transferFromSelf), dst, amt);
    }
    function proveWithTransferFromSelf(address src, address dst, uint amt) public {
        verifyMove(address(transferFromSelf), src, dst, amt);
    }

    // success with standard erc20
    function proveWithStandardERC20(address dst, uint amt) public {
        verifyMove(address(erc20), dst, amt);
    }
    function proveWithStandardERC20(address src, address dst, uint amt) public {
        verifyMove(address(erc20), src, dst, amt);
    }

    // always fails if token returns false
    function proveFailWithReturnsFalse(address dst, uint amt) public {
        verifyMove(address(returnsFalse), dst, amt);
    }
    function proveFailWithReturnsFalse(address src, address dst, uint amt) public {
        verifyMove(address(returnsFalse), src, dst, amt);
    }

    // --- utils ---

    function verifyMove(address token, address dst, uint amt) internal {
        uint preBal = ERC20(token).balanceOf(dst);
        move(token, dst, amt);
        uint postBal = ERC20(token).balanceOf(dst);

        if (dst == address(this)) {
            assertEq(preBal, postBal);
        } else {
            assertEq(postBal - preBal, amt);
        }
    }
    function verifyMove(address token, address src, address dst, uint amt) internal {
        approve(token, src, address(this), amt);
        move(token, src, amt);

        uint preBal = ERC20(token).balanceOf(dst);
        move(token, src, dst, amt);
        uint postBal = ERC20(token).balanceOf(dst);

        if (src == dst) {
            assertEq(preBal, postBal);
        } else {
            assertEq(postBal - preBal, amt);
        }
    }

    function approve(address token, address src, address dst, uint amt) internal {
        uint slot = token == address(erc20) ? 3 : 2;
        hevm.store(
            token,
            keccak256(abi.encode(dst, keccak256(abi.encode(src, uint256(slot))))),
            bytes32(uint(amt))
        );
        assertEq(ERC20(token).allowance(src, dst), amt, "wrong allowance");
    }
}
