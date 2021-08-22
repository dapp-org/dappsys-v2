// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

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

uint constant WAD = 10 ** 18;
uint constant RAY = 10 ** 27;
uint constant RAD = 10 ** 45;

function wmul(uint x, uint y) pure returns (uint z) {
    z = (x * y) / WAD;
}
function rmul(uint x, uint y) pure returns (uint z) {
    z = (x * y) / RAY;
}
function wdiv(uint x, uint y) pure returns (uint z) {
    z = (x * WAD) / y;
}
function rdiv(uint x, uint y) pure returns (uint z) {
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
function rpow(uint x, uint n, uint b) pure returns (uint z) {
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

