# Dappsys V2

A simplified and modernized dappsys contract library.

- `auth.sol`: auth with `rely` / `deny`
- `math.sol`: fixed point numeric routines
- `token.sol`: a minimal mintable / burnable erc20 with `permit`
- `proxy.sol`: DSProxy rewritten to use a `create2` based cache
- `delay.sol`: a simplified `ds-pause`

## Development

```
nix-shell
dapp build
```
