# Dappsys V2

A simplified and modernized dappsys contract library.

**WARNING**: This is still very much a work in progress. Do not use these contracts in production!

- `auth.sol`: auth with `rely` / `deny`
- `math.sol`: fixed point numeric routines
- `move.sol`: erc20 `transferFrom` wrapper
- `erc20.sol`: erc20 interface definition
- `token.sol`: a minimal mintable / burnable erc20 with `permit`
- `proxy.sol`: DSProxy rewritten to use a `create2` based cache
- `delay.sol`: a simplified `ds-pause`
- `value.sol`: `DSValue` without `DSThing`

## Development

```
nix-shell
make build     # build contracts
make test      # test contracts
make doc-build # build docs
make doc-serve # serve docs and rebuild on changes
```
