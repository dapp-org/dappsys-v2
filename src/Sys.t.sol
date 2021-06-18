pragma solidity ^0.6.7;

import "ds-test/test.sol";

import "./Sys.sol";

contract SysTest is DSTest {
    Sys sys;

    function setUp() public {
        sys = new Sys();
    }

    function testFail_basic_sanity() public {
        assertTrue(false);
    }

    function test_basic_sanity() public {
        assertTrue(true);
    }
}
