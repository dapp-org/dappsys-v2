// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

// --- min / max ---

function min(uint x, uint y) pure returns (uint z) {
    return x <= y ? x : y;
}
function max(uint x, uint y) pure returns (uint z) {
    return x >= y ? x : y;
}
function imin(int x, int y) pure returns (int z) {
    return x <= y ? x : y;
}
function imax(int x, int y) pure returns (int z) {
    return x >= y ? x : y;
}

// --- fixed point routines ---

type Wad is uint;
type Ray is uint;
type Rad is uint;

uint constant WAD = 10 ** 18;
uint constant RAY = 10 ** 27;
uint constant RAD = 10 ** 45;

function add(Wad x, Wad y) pure returns (Wad) {
    return Wad.wrap(Wad.unwrap(x) + Wad.unwrap(y));
}
function add(Ray x, Ray y) pure returns (Ray) {
    return Wad.wrap(Wad.unwrap(x) + Wad.unwrap(y));
}
function add(Rad x, Rad y) pure returns (Rad) {
    return Wad.wrap(Wad.unwrap(x) + Wad.unwrap(y));
}

function sub(Wad x, Wad y) pure returns (Wad) {
    return Wad.wrap(Wad.unwrap(x) - Wad.unwrap(y));
}
function sub(Ray x, Ray y) pure returns (Ray) {
    return Wad.wrap(Wad.unwrap(x) - Wad.unwrap(y));
}
function sub(Rad x, Rad y) pure returns (Rad) {
    return Wad.wrap(Wad.unwrap(x) - Wad.unwrap(y));
}

function wmul(Wad x, Wad y) pure returns (Wad) {
    return Wad.wrap(wmul_(Wad.unwrap(x), Wad.unwrap(y)));
}
function wmul(Ray x, Wad y) pure returns (Ray) {
    return Ray.wrap(wmul_(Ray.unwrap(x), Wad.unwrap(y)));
}
function wmul(Wad x, Ray y) pure returns (Ray) {
    return Ray.wrap(wmul_(Wad.unwrap(x), Ray.unwrap(y)));
}
function wmul(Rad x, Wad y) pure returns (Rad) {
    return Rad.wrap(wmul_(Rad.unwrap(x), Wad.unwrap(y)));
}
function wmul(Wad x, Rad y) pure returns (Rad) {
    return Rad.wrap(wmul_(Wad.unwrap(x), Rad.unwrap(y)));
}

function rmul(Ray x, Ray y) pure returns (Ray) {
    return Ray.wrap(rmul_(Ray.unwrap(x), Ray.unwrap(y)));
}
function rmul(Ray x, Wad y) pure returns (Wad) {
    return Wad.wrap(rmul_(Ray.unwrap(x), Wad.unwrap(y)));
}
function rmul(Wad x, Ray y) pure returns (Wad) {
    return Wad.wrap(rmul_(Wad.unwrap(x), Ray.unwrap(y)));
}
function rmul(Rad x, Ray y) pure returns (Rad) {
    return Rad.wrap(rmul_(Rad.unwrap(x), Ray.unwrap(y)));
}
function rmul(Ray x, Rad y) pure returns (Rad) {
    return Rad.wrap(rmul_(Ray.unwrap(x), Rad.unwrap(y)));
}

function wdiv(Wad x, Wad y) pure returns (Wad) {
    return Wad.wrap(wdiv_(Wad.unwrap(x), Wad.unwrap(y)));
}
function wdiv(Ray x, Wad y) pure returns (Ray) {
    return Ray.wrap(wdiv_(Ray.unwrap(x), Wad.unwrap(y)));
}
function wdiv(Rad x, Wad y) pure returns (Rad) {
    return Rad.wrap(wdiv_(Rad.unwrap(x), Wad.unwrap(y)));
}

function rdiv(Wad x, Ray y) pure returns (Wad) {
    return Wad.wrap(rdiv_(Wad.unwrap(x), Ray.unwrap(y)));
}
function rdiv(Ray x, Ray y) pure returns (Ray) {
    return Ray.wrap(rdiv_(Ray.unwrap(x), Ray.unwrap(y)));
}
function rdiv(Rad x, Ray y) pure returns (Rad) {
    return Rad.wrap(rdiv_(Rad.unwrap(x), Ray.unwrap(y)));
}

function wmul_(uint x, uint y) pure returns (uint z) {
    z = (x * y) / WAD;
}
function rmul_(uint x, uint y) pure returns (uint z) {
    z = (x * y) / RAY;
}
function wdiv_(uint x, uint y) pure returns (uint z) {
    z = (x * WAD) / y;
}
function rdiv_(uint x, uint y) pure returns (uint z) {
    z = (x * RAY) / y;
}

// This famous algorithm is called "exponentiation by squaring"
// and calculates x^n with x as fixed-point of base b and n as regular unsigned.
//
// It's O(log n), instead of O(n) for naive repeated multiplication.
//
// These facts are why it works:
//
//  If n is even, then x^n = (x^2)^(n/2).
//  If n is odd,  then x^n = x * x^(n-1),
//   and applying the equation for even x gives
//    x^n = x * (x^2)^((n-1) / 2).
//
//  Also, EVM division is flooring and
//    floor[(n-1) / 2] = floor[n / 2].
//
function pow(Wad x, uint n) pure returns (Wad) {
    return Wad.wrap(pow(Wad.unwrap(x), n, WAD));
}
function pow(Ray x, uint n) pure returns (Ray) {
    return Ray.wrap(pow(Ray.unwrap(x), n, RAY));
}
function pow(Rad x, uint n) pure returns (Rad) {
    return Rad.wrap(pow(Rad.unwrap(x), n, RAD));
}
function pow(uint x, uint n, uint b) pure returns (uint z) {
    assembly {
        switch x case 0 {switch n case 0 {z := b} default {z := 0}}
        default {
            switch mod(n, 2) case 0 { z := b } default { z := x }
            let half := div(b, 2)  // for rounding.
            for { n := div(n, 2) } n { n := div(n,2) } {
                let xx := mul(x, x)
                if iszero(eq(div(xx, x), x)) { revert(0,0) }
                let xxRound := add(xx, half)
                if lt(xxRound, xx) { revert(0,0) }
                x := div(xxRound, b)
                if mod(n,2) {
                    let zx := mul(z, x)
                    if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) { revert(0,0) }
                    let zxRound := add(zx, half)
                    if lt(zxRound, zx) { revert(0,0) }
                    z := div(zxRound, b)
                }
            }
        }
    }
}

// --- square root ---

// babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method)
// implementation taken from uniswap-v2-core:
//   https://github.com/Uniswap/uniswap-v2-core/blob/4dd59067c76dea4a0e8e4bfdda41877a6b16dedc/contracts/libraries/Math.sol#L11
// proof of correctness & termination: https://dapp.org.uk/reports/uniswapv2.html#org1a9132f
// proofs of safety in smt for unchecked for both cases of addition:
/*
    ;; y / 2 + 1;
    (declare-const y (_ BitVec 256))
    (define-const two (_ BitVec 256) (_ bv2 256))
    (define-const one (_ BitVec 256) (_ bv1 256))
    (assert (bvult (bvadd (bvudiv y two) one) (bvudiv y two)))
    (check-sat)
    ;; unsat
*/
/*
    ;; y / x + x
    (declare-const x (_ BitVec 256))
    (declare-const y (_ BitVec 256))
    (define-const two (_ BitVec 256) (_ bv2 256))
    (define-const one (_ BitVec 256) (_ bv1 256))
    (assert (= x (bvadd (bvudiv y two) one)))
    (assert (bvult (bvadd (bvudiv y x) x) (bvudiv y x)))
    (check-sat)
    ;; unsat
*/
function sqrt(uint y) pure returns (uint z) {
    unchecked {
        if (y > 3) {
            z = y;
            uint x = y / 2 + 1;
            while (x < z) {
                z = x;
                x = (y / x + x) / 2;
            }
        } else if (y != 0) {
            z = 1;
        }
    }
}

