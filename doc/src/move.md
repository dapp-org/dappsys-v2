# Move

[`source code`](https://github.com/dapp-org/dappsys-v2/blob/main/src/move.sol) // [`tests`](https://github.com/dapp-org/dappsys-v2/blob/main/src/test/move.t.sol)

`Move` proves a wrapper around the erc20 transfer operations that handles two of the more common edge cases:

  - missing returns
  - transfer fees

It can handle erc20 tokens that are missing a return value (e.g. `BNB`, `USDT`), tokens that return
`false` instead of reverting on failure (e.g. `ZRX`), as well as tokens that correctly return `true`
if the transfer was performed successfully. It cannot handle tokens that return `false` for a
successful transfer (e.g. Tether Gold).

It additionally checks to ensure that the amount received is the same as the amount that was sent,
and reverts if that was not the case, providing protection against tokens that take a fee.

Be aware that every token interaction is dangerous and should be made with great care, and that the
usage of a wrapper such as this one protects you from only a very small class of potential problems.
If at all possible use a contract level allow list and carefully audit every token that your system
will be interacting with.

See the [weird-erc20](https://github.com/d-xo/weird-erc20) repo for a non exhaustive list of surprising mainnet tokens.

## Interface

### `move(address token, address dst, uint amt)`

Calls `token.transferFrom(msg.sender, dst, amt)`.

- Reverts if `token` returns a boolean `false`
- Reverts if `dst`'s balance has not increased by `amt`

**NOTE**: does not revert if `src`'s balance has not decreased by `amt`

### `move(address token, address src, address dst, uint amt)`

Calls `token.transferFrom(src, dst, amt)`.

- Reverts if `token` returns a boolean `false`
- Reverts if `dst`'s balance has not increased by `amt`

**NOTE**: does not revert if `src`'s balance has not decreased by `amt`
