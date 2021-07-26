# Move

[`source code`](https://github.com/dapp-org/dappsys-v2/blob/main/src/move.sol) // [`tests`](https://github.com/dapp-org/dappsys-v2/blob/main/src/test/move.t.sol)

`Move` proves a wrapper around the erc20 transfer operations that handles erc20 tokens with a
missing return value.

It can handle erc20 tokens that are missing a return value (e.g. `BNB`, `USDT`), tokens that return
`false` instead of reverting on failure (e.g. `ZRX`), as well as tokens that correctly return `true`
if the transfer was performed successfully. It cannot handle tokens that return `false` for a
successful transfer (e.g. Tether Gold).

Be aware that every token interaction is dangerous and should be made with great care, and that the
usage of a wrapper such as this one protects you from only a very small class of potential problems.
If at all possible use a contract level allow list and carefully audit every token that your system
will be interacting with.

See the [weird-erc20](https://github.com/d-xo/weird-erc20) repo for a non exhaustive list of surprising mainnet tokens.

## Interface

### `move(address token, address dst, uint amt)`

- Calls `token.transferFrom(address(this), dst, amt)`
- Reverts if the call to `transferFrom` reverts
- Reverts if `token` returns a boolean `false`.

### `move(address token, address src, address dst, uint amt)`

- Calls `token.transferFrom(src, dst, amt)`
- Reverts if the call to `transferFrom` reverts
- Reverts if `token` returns a boolean `false`.
