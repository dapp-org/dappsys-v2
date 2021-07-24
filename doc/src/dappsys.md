# Dappsys

Dappsys is a set of minimal utility contracts targeting solidity versions above 0.8. The following
contracts are included:

## Mixins

- `auth.sol`: multi-owner auth
- `math.sol`: fixed point numeric routines
- `move.sol`: erc20 `transferFrom` wrapper

## Standalone Contracts

- `token.sol`: an erc20 token with authed mint / burn and `permit`
- `proxy.sol`: execute atomic transaction sequences from a persistent identity
- `delay.sol`: a governance timelock delay
- `value.sol`: an on chain beacon for off chain oracles

## Interface Definitions

- `erc20.sol`
