// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

import {ERC20} from "./erc20.sol";

contract Move {
    function move(address token, address dst, uint amt) internal {
        move(token, address(this), dst, amt);
    }
    function move(address token, address src, address dst, uint amt) internal {
        (bool res, bytes memory out) = token.call(abi.encodeWithSelector(ERC20.transferFrom.selector, src, dst, amt));
        require(res && (out.length == 0 || abi.decode(out, (bool))), 'move/transfer-failed');
    }
}
