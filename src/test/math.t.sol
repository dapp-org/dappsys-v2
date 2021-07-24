// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.4;

import {Math} from "../math.sol";
import {DSTest} from "ds-test/test.sol";

contract TestMath is Math, DSTest {

    // TODO: make these min / max tests symbolic once
    // https://github.com/dapphub/dapptools/issues/705 is fixed
    function testMin(uint x, uint y) public {
        if (x <= y) {
            assertEq(min(x, y), x);
        } else {
            assertEq(min(x, y), y);
        }
    }

    function testMax(uint x, uint y) public {
        if (x >= y) {
            assertEq(max(x, y), x);
        } else {
            assertEq(max(x, y), y);
        }
    }

    function testIMin(int x, int y) public {
        if (x <= y) {
            assertEq(imin(x, y), x);
        } else {
            assertEq(imin(x, y), y);
        }
    }

    function testIMax(int x, int y) public {
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
       tests rpow for a base of 1
       TODO: investigate counterexample: testRpow(42,198)
    */
    function testRpow(uint8 _x, uint8 _n) public {
        // avoid overflow
        uint x = _x % 50;
        uint n = _n % 50;

        assertEq(rpow(x, n, 1), x ** n);
    }
}
