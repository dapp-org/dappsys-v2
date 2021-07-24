# `Auth`

`Auth` implements a multi owner authorization pattern.

An owner is known as a `ward` of the contract. Wards can make other users wards by calling
`rely(address usr)`, or they can demote other wards by calling `deny(address usr)`.

## Extending

``
