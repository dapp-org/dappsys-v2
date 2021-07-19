// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.4;

import {Math} from "../math.sol";
import {DSTest} from "ds-test/test.sol";

contract TestMath is Math, DSTest {

    function proveMin(uint x, uint y) public {
        if (x <= y) {
            assertEq(min(x, y), x);
        } else {
            assertEq(min(x, y), y);
        }
    }

    function proveMax(uint x, uint y) public {
        if (x >= y) {
            assertEq(max(x, y), x);
        } else {
            assertEq(max(x, y), y);
        }
    }

    function proveIMin(int x, int y) public {
        if (x <= y) {
            assertEq(imin(x, y), x);
        } else {
            assertEq(imin(x, y), y);
        }
    }

    function proveIMax(int x, int y) public {
        if (x >= y) {
            assertEq(imax(x, y), x);
        } else {
            assertEq(imax(x, y), y);
        }
    }

    function testSqrt(uint x) public {
        uint root = sqrt(x);
        uint next = root + 1;

        // ignore cases where next * next overflows
        unchecked { if (next * next < next) return; }

        assertTrue(root * root <= x && next * next > x);
    }

    /*
       tests rpow against a naive implementation (repeated multiplication)
    */
    function testRpow(uint8 x, uint8 n) public {
        compareRpow(x, n, WAD);
        compareRpow(x, n, RAY);
        compareRpow(x, n, RAD);
    }
    function compareRpow(uint8 x, uint8 n, uint b) public {
        uint naive = b;
        if (x == 0) {
            naive = n == 0 ? b : 0;
        } else {
            for (uint i = 0; i <= n; i++) {
                // ignore cases where we overflow here
                unchecked { if (naive * x < naive) return; }
                unchecked { if ((naive * x) + (b / 2) < (naive * x)) return; }

                // multiply and account for rounding
                naive = ((naive * x) + (b / 2)) / b;
            }
        }

        assertEq(rpow(x, n, b), naive);
    }
}
