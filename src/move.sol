// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

import {ERC20} from "./erc20.sol";

contract Move {
    function move(address token, address dst, uint amt) public {
        move(token, msg.sender, dst, amt);
    }
    function move(address token, address src, address dst, uint amt) public {
        uint preBal = ERC20(token).balanceOf(dst);

        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(ERC20.transferFrom.selector, src, dst, amt));

        require(success && (data.length == 0 || abi.decode(data, (bool))), 'move/transfer-failed');

        // revert if the amount sent does not match amt, this protects against tokens that take a fee from the recipient
        uint postBal = ERC20(token).balanceOf(dst);
        require(postBal - preBal == amt, "move/incorrect-amt-received");
    }
}
