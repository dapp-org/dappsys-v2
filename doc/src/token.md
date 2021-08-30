# `Token`

[`source code`](https://github.com/dapp-org/dappsys-v2/blob/main/src/token.sol) // [`tests`](https://github.com/dapp-org/dappsys-v2/blob/main/src/test/token.t.sol)

`Token` implements an ERC20 compatible token with the addition of auth protected `mint` and `burn`
methods, as well as [`EIP-2612`](https://eips.ethereum.org/EIPS/eip-2612) (`permit`) signature based
delegation.

The token is fully compliant with the [ERC20 interface specification](https://eips.ethereum.org/EIPS/eip-20).

## Semantics

In terms of semantics the token is designed to be minimally surprising and as such does not implement any of the following:

- blocklists
- admin controlled pause
- transfer fees
- reverts on transfers to or from the zero address
- reverts on approval to or from the zero address
- reverts on approvals when an non-zero approval is already in place
- reverts on zero value transfers
- reverts on large transfers / approvals

The token `decimals` is hardcoded to `18`.

The token is immutable and cannot be upgraded once deployed.

A call to `transferFrom(address(this), usr, amt)` is semantically exactly the same as a call to `transfer(usr, amt)`.

### `mint(address usr, uint amt) auth`

- Allows a ward of the token to mint `amt` tokens to `usr`.
- Reverts if the caller is not a ward.
- Reverts if `totalSupply` or `balanceOf[usr]` would overflow a `uint256`.
- If execution succeeds, emits an event `Transfer(address(0), usr, amt)`.

### `burn(address usr, uint amt) auth`

- Allows a ward of the token to burn `amt` tokens from `usr`.
- Reverts if the caller is not a ward.
- Reverts if `totalSupply` or `balanceOf[usr]` would be less than 0.
- If execution succeeds, emits an event `Transfer(usr, address(0), amt)`.

### `approve(address usr, uint amt) returns (bool)`

- Allows `usr` to spend `amt` of the callers tokens.
- An existing approval from the caller to `usr` will be overridden.
- Emits an event `Approval(msg.sender, usr, amt)`.
- Returns `true`

Note that compliance with the ERC20 standard has been prioritised here and this token implementation
is vulnerable to the [ERC20 approval
race](https://docs.google.com/document/d/1YLPtQxZu1UAvO9cZ1O2RPXBbT0mooh4DYKjA_jp-RLM).

### `transfer(address usr, uint amt) returns (bool)`

- Sends `amt` tokens from the caller to `usr`.
- Reverts if the caller does not have sufficient balance for the transfer.
- If execution succeeds, emits and event `Transfer(msg.sender, dst, amt)`.
- If execution succeeds, returns `true` (or reverts otherwise).

### `transferFrom(address src, address dst, uint amt) returns (bool)`

- Sends `amt` tokens from `src` to `dst`.
- Reverts if the caller has not been approved for at least `amt` by `src`.
- Reverts if `src` does not have sufficient balance for the transfer.
- If the caller has been approved for `type(uint).max` by `src`, then the allowance from `src` to
    the caller will not be decreased.
- If the caller is also `src` then the allowance from `src` to caller will not be decreased. This
    means that a call to `transferFrom(address(this), usr, amt)` is semantically equivalent to
    `transfer(usr, amt)`.
- Aside from the above two cases, the allowance from `src` to `caller` will be decreased by `amt`.
- If execution succeeds, emits and event `Transfer(src, dst, amt)`.
- If execution succeeds, returns `true` (or reverts otherwise).

## Permit

The token implements [`EIP-2612`](https://eips.ethereum.org/EIPS/eip-2612), and as such allows
delegation of control over token balances via a signed message. This has two main benefits:

- It allows the construction of "gassless" relayer based workflows where users can pay for
    interactions involving the token without having to hold ether.
- It allows users to both approve a contract on their tokens and then have the contract pull those
    tokens in a single transaction.

