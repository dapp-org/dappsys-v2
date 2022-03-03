// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

import "../math.sol";
import {DSTest} from "ds-test/test.sol";

contract TestMath is DSTest {

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
    */
    function testRpow(uint8 _x, uint8 _n) public {
        // avoid overflow
        uint x = _x % 45;
        uint n = _n % 45;
        assertEq(rpow(x, n, 1), x ** n);
    }

    function testWmulWW(Wad x, Wad y) public {
        // ignore overflow
        unchecked {
            if (Wad.unwrap(y) == 0) return;
            if (Wad.unwrap(x) * WAD / WAD != Wad.unwrap(x)) return;
            if (Wad.unwrap(x) * Wad.unwrap(y) / Wad.unwrap(y) != Wad.unwrap(x)) return;
        }

        // if we ignore the last 80 bits then wmul and wdiv are inverses
        uint precision = 80;

        assertEq(
            Wad.unwrap(wdiv(wmul(x, y), y)) >> precision,
            Wad.unwrap(x) >> precision
        );
        assertEq(
            Wad.unwrap(wmul(wdiv(x, y), y)) >> precision,
            Wad.unwrap(x) >> precision
        );
    }

    function testWmulGas(uint x, uint y) public {
        // ignore overflow
        unchecked { if (x * y / y != x) return; }

        Wad xw = Wad.wrap(x);
        Wad yw = Wad.wrap(y);

        uint preGasTyped = gasleft();
        Wad rw = wmul(xw, yw);
        uint postGasTyped = gasleft();

        uint preGasBare = gasleft();
        uint rb = wmul_(x, y);
        uint postGasBare = gasleft();

        // results are the same
        assertEq(Wad.unwrap(rw), rb);
        // gas usage is identical
        assertEq(postGasTyped - preGasTyped, postGasBare - preGasBare);
    }
}
