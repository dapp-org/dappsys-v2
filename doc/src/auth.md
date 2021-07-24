# `Auth`

`Auth` implements a multi owner authorization pattern.

An owner is known as a `ward` of the contract. Wards can make other users wards by calling
`rely(address usr)`, or they can demote other wards by calling `deny(address usr)`.

A contract that inherits from `Auth` will have the `auth` modifier available, which will revert if
the caller is not a ward.

The constructor of `Auth` takes an address that will be made the initial ward.

## Properties

- authed methods can only be called by wards
- wards can only be added and removed by other wards
- all changes to ward status are logged

## Reference

### Data

- `mapping (address => bool)`: wards status for every ethereum address

### Methods

**`rely(address usr)`**:

- makes `usr` a ward
- logs a `Rely` event

**`deny(address usr)`**:

- removes `usr` as a ward
- logs a `Deny` event

### Events

- `Rely(address usr)`: `usr` is now a ward
- `Deny(address usr)`: `usr` is no longer a ward

## Example


```solidity
{{#include examples/auth.sol}}
```
