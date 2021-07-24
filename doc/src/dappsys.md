# Dappsys

**WARNING**: This is still very much a work in progress. Do not use these contracts in production!

Dappsys is a set of minimal utility contracts targeting solidity versions above 0.8.

The contracts are written in a style that attempts wherever possible to avoid the following:

- dependencies
- inheritance
- external calls
- branching
- looping
- dynamic types

Alignment and aesthetics are considered to be beneficial to auditability and so are prioritised.

Wherever possible security properties have been verified formally.

## Contracts

### Mixins

- [`auth.sol`](./auth.md): multi-owner auth
- `math.sol`: fixed point numeric routines
- `move.sol`: erc20 `transferFrom` wrapper

### Standalone Contracts

- `token.sol`: an erc20 token with authed mint / burn and `permit`
- `proxy.sol`: execute atomic transaction sequences from a persistent identity
- `delay.sol`: a governance timelock delay
- `value.sol`: an on chain beacon for off chain oracles

### Interface Definitions

- `erc20.sol`
