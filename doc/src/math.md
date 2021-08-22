# `Math`

[`source code`](https://github.com/dapp-org/dappsys-v2/blob/main/src/math.sol) // [`tests`](https://github.com/dapp-org/dappsys-v2/blob/main/src/test/math.t.sol)

`Math` implements a few common numeric helpers:

- fixed point division, multiplication and exponentiation
- a [babylonian](https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method) integer square root routine
- min and max methods for both `int` and `uint` types

## Fixed Point Arithmetic

The fixed point multiplication and division routines are implemented for three different units:

- `wad`: fixed point decimal with 18 decimals (for basic quantities, e.g. balances)
- `ray`: fixed point decimal with 27 decimals (for precise quantites, e.g. ratios)
- `rad`: fixed point decimal with 45 decimals (result of integer multiplication with a `wad` and a `ray`)

Generally, `wad` should be used additively and `ray` should be used multiplicatively. It usually
doesn't make sense to multiply a `wad` by a `wad` (or a `rad` by a `rad`).

For convenience three useful constants are provided, each representing one in each of the above units:

- `WAD`: `1 ** 18`
- `RAD`: `1 ** 27`
- `RAY`: `1 ** 45`

### Multiplication

Two multiplication operators are provided in `Math`:

- `wmul`: multiply a quantity by a `wad`. Precision is lost.
- `rmul`: multiply a quantity by a `ray`. Precision is lost.

Both `wmul` and `rmul` will always round down.

They can be used sensibly with the following combination of units:

- `wmul(wad, wad) -> wad`
- `wmul(ray, wad) -> ray`
- `wmul(rad, wad) -> rad`
- `rmul(wad, ray) -> wad`
- `rmul(ray, ray) -> ray`
- `rmul(rad, ray) -> rad`

### Division

Two division operators are provided in `Math`:

- `wdiv`: divide a quantity by a `wad`. Precision is lost.
- `rdiv`: divide a quantity by a `ray`. Precision is lost.

Both `wdiv` and `rdiv` will always round down.

They can be used sensibly with the following combination of units:

- `wdiv(wad, wad) -> wad`
- `wdiv(ray, wad) -> ray`
- `wdiv(rad, wad) -> rad`
- `rdiv(wad, ray) -> wad`
- `rdiv(ray, ray) -> ray`
- `rdiv(rad, ray) -> rad`

### Exponentiation

The fixed point exponentiation routine (`rpow`) is implemented using [exponentiation by
squaring](https://en.wikipedia.org/wiki/Exponentiation_by_squaring), giving a complexity of `O(log
n)` (instead of `O(n)` for naive repeated multiplication).

`rpow` accepts three parameters:

- `x`: the base
- `n`: the exponent
- `b`: the fixed point numeric base (e.g. 18 for a `wad`)

calling `rpow(x, n, b)` will interpret `x` as a fixed point integer with `b` digits of precision,
and raise it to the power of `n`.

## Square Root

`sqrt` is an algorithm for approximating the square root of any given integer using the babylonian
method. The implementation is taken from
[uniswap-v2-core](https://github.com/Uniswap/uniswap-v2-core/blob/4dd59067c76dea4a0e8e4bfdda41877a6b16dedc/contracts/libraries/Math.sol#L11).
It can be shown that it terminates in [at most 255 loop
iterations](https://dapp.org.uk/reports/uniswapv2.html#org1a9132f).

Calling `sqrt(x)` will find the number `y` such that `y * y <= x` and `(y + 1) * (y + 1) > x`

## Min / Max helpers

Four trvial `min` / `max` helpers are provided:

- `min(uint x, uint y)`: finds the minimum of two uints
- `max(uint x, uint y)`: finds the maximum of two uints
- `imin(int x, int y)`:  finds the minimum of two ints
- `imax(int x, int y)`:  finds the maximum of two ints
