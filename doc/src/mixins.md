# Mixins

Although inheritance and imports are generally avoided within dappsys there are a few cases where
the benefits of code reuse outweigh the costs to auditability imposed by splitting contract logic
across many files.

These contracts can be inherited from to provide common functionality:

- [`auth.sol`](./auth.md): multi owner auth
- [`math.sol`](./math.md): common numeric routines
- [`move.sol`](./move.md): erc20 transferFrom wrapper
