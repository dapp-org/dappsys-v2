// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.4;

import {DSTest} from "ds-test/test.sol";
import {Hevm} from "./hevm.sol";
import {Token} from "../token.sol";
import {ERC20} from "../erc20.sol";

contract TestToken is DSTest {
    Hevm hevm = Hevm(HEVM_ADDRESS);
    Token token = new Token("Token", "TKN");

    function testMetaData(string memory name, string memory symbol) public {
        Token tkn = new Token(name, symbol);
        assertEq(tkn.name(), name);
        assertEq(tkn.symbol(), symbol);
    }

    function proveMint(address usr, uint amt) public {
        token.mint(usr, amt);

        assertEq(token.totalSupply(), amt);
        assertEq(token.balanceOf(usr), amt);
    }

    function proveBurn(address usr, uint amt0, uint amt1) public {
        if (amt1 > amt0) return; // mint amount must exceed burn amount

        token.mint(usr, amt0);
        token.burn(usr, amt1);

        assertEq(token.totalSupply(), amt0 - amt1);
        assertEq(token.balanceOf(usr), amt0 - amt1);
    }

    function proveApprove(address usr, uint amt) public {
        bool ret = token.approve(usr, amt);

        assertTrue(ret);
        assertEq(token.allowance(address(this), usr), amt);
    }

    function proveTransfer(address usr, uint amt) public {
        token.mint(address(this), amt);

        bool ret = token.transfer(usr, amt);

        assertTrue(ret);
        assertEq(token.totalSupply(), amt);

        if (address(this) == usr) {
            assertEq(token.balanceOf(address(this)), amt);
        } else {
            assertEq(token.balanceOf(address(this)), 0);
            assertEq(token.balanceOf(usr), amt);
        }
    }

    function proveFailTransferIsufficientBalance(address dst, uint mintAmt, uint sendAmt) public {
        require(mintAmt < sendAmt);

        token.mint(address(this), mintAmt);
        token.transfer(dst, sendAmt);
    }

    function proveTransferFrom(address src, address dst, uint approval, uint amt) public {
        if (amt > approval) return; // src must approve this for more than amt

        token.mint(src, amt);
        approve(src, address(this), approval);

        bool ret = token.transferFrom(src, dst, amt);

        assertTrue(ret);
        assertEq(token.totalSupply(), amt);

        uint app = src == address(this) || approval == type(uint).max
                 ? approval
                 : approval - amt;
        assertEq(token.allowance(src, address(this)), app);

        if (src == dst) {
            assertEq(token.balanceOf(src), amt);
        } else {
            assertEq(token.balanceOf(src), 0);
            assertEq(token.balanceOf(dst), amt);
        }
    }

    function proveFailTransferFromInsufficientAllowance(address src, address dst, uint approval, uint amt) public {
        require(approval < amt);
        require(src != address(this));

        token.mint(src, amt);
        approve(src, address(this), approval);
        token.transferFrom(src, dst, amt);
    }

    function proveFailTransferFromIsufficientBalance(address src, address dst, uint mintAmt, uint sendAmt) public {
        require(mintAmt < sendAmt);

        token.mint(src, mintAmt);
        approve(src, address(this), sendAmt);
        token.transferFrom(src, dst, sendAmt);
    }

    function approve(address src, address dst, uint amt) internal {
        hevm.store(
            address(token),
            keccak256(abi.encode(dst, keccak256(abi.encode(src, uint256(5))))),
            bytes32(uint(amt))
        );
        assertEq(token.allowance(src, dst), amt, "wrong allowance");
    }
}

contract TestInvariants is DSTest {
    BalanceSum balanceSum;
    address[] targetContracts_;

    function targetContracts() public view returns (address[] memory) {
      return targetContracts_;
    }

    function setUp() public {
        balanceSum = new BalanceSum();
        targetContracts_.push(address(balanceSum));
    }

    function invariantBalanceSum() public {
        assertEq(balanceSum.token().totalSupply(), balanceSum.sum());
    }
}

contract BalanceSum {
    Token public token = new Token("token", "TKN");
    uint public sum;

    function mint(address usr, uint amt) external {
        token.mint(usr, amt);
        sum += amt;
    }
    function burn(address usr, uint amt) external {
        token.burn(usr, amt);
        sum -= amt;
    }
    function approve(address dst, uint amt) external returns (bool) {
        return token.approve(dst, amt);
    }
    function transferFrom(address src, address dst, uint amt) external returns (bool) {
        return token.transferFrom(src, dst, amt);
    }
}
