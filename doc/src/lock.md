# Lock

[`source code`](https://github.com/dapp-org/dappsys-v2/blob/main/src/lock.sol) // [`tests`](https://github.com/dapp-org/dappsys-v2/blob/main/src/test/lock.t.sol)

`Lock` provides a reentrancy mutex. Contracts that inherit from `Lock` will have the `lock` modifier
available, any subcall resulting from a call to a locked method will revert if it attempts to call
any other locked method on the same contract.

Note that reentrant calls to methods that are not protected by the lock modifier will still succeed.

## Interface

#### Data

- `bool unlocked`: lock status

#### Modifiers

**`lock()`**:

reverts if `unlocked` is true, and sets it to `false` for the duration of the call to the wrapped method.

## Example

```solidity
{{#include examples/lock.sol}}
```
