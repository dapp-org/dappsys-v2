// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

import {ERC20} from "./erc20.sol";

bytes4 constant TRANSFER = ERC20.transfer.selector;
bytes4 constant TRANSFER_FROM = ERC20.transferFrom.selector;

// implementation taken from uni-v2:
//   https://github.com/Uniswap/uniswap-v2-core/blob/4dd59067c76dea4a0e8e4bfdda41877a6b16dedc/contracts/UniswapV2Pair.sol#L44
contract Move {
    function move(address token, address dst, uint amt) internal {
        (bool res, bytes memory out) = token.call(abi.encodeWithSelector(TRANSFER, dst, amt));
        require(res && (out.length == 0 || abi.decode(out, (bool))), 'move/transfer-failed');
    }
    function move(address token, address src, address dst, uint amt) internal {
        (bool res, bytes memory out) = token.call(abi.encodeWithSelector(TRANSFER_FROM, src, dst, amt));
        require(res && (out.length == 0 || abi.decode(out, (bool))), 'move/transfer-failed');
    }
}
