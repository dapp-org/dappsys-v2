// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.4;

import {ERC20} from "./erc20.sol";

/*
    ERC20 transferFrom wrapper that handles a few of the more common edge cases:

      - missing returns
      - transfer fees

    Be aware that every token interaction is dangerous and should be made with
    great care, and that the usage of a wrapper such as this one protects you
    from only a very small class of potential problems. If at all possible use
    a contract level allow list and carefully audit every token that your
    system will be interacting with.

    See https://github.com/d-xo/weird-erc20 for a non exhaustive list of weird tokens.
*/
contract Move {
    function move(address token, address src, address dst, uint amt) public {
        uint preBal = ERC20(token).balanceOf(dst);

        (bool success, bytes memory data) = token.call(abi.encodeWithSelector(ERC20.transferFrom.selector, src, dst, amt));

        // handle tokens that do not return a bool, note that handling every
        // permutation of bool return weirdness is impossible here due to the
        // existance of tether gold: https://github.com/d-xo/weird-erc20#missing-return-values
        require(success && (data.length == 0 || abi.decode(data, (bool))), 'move/transfer-failed');

        // revert if the amount sent does not match amt, this protects against tokens that take a fee from the recipient
        uint postBal = ERC20(token).balanceOf(dst);
        require(postBal - preBal == amt, "move/incorrect-amt-received");
    }
}
