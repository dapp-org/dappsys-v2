// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.6;

import {Auth} from "./auth.sol";

contract Token is Auth {

    // --- data ---

    string  public name;
    string  public symbol;
    uint8   public constant decimals = 18;

    uint public totalSupply;

    mapping (address => uint)                      public balanceOf;
    mapping (address => mapping (address => uint)) public allowance;

    mapping(address => uint) public nonces;
    bytes32 public constant PERMIT_TYPEHASH =
        keccak256(
            "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
        );

    // --- logs ---

    event Approval(address indexed src, address indexed dst, uint amt);
    event Transfer(address indexed src, address indexed dst, uint amt);

    // --- init ---

    constructor(string memory _name, string memory _symbol)
        Auth(msg.sender)
    {
        name = _name;
        symbol = _symbol;
    }

    // --- admin ---

    function mint(address usr, uint amt) external auth {
        balanceOf[usr] += amt;
        totalSupply    += amt;
        emit Transfer(address(0), usr, amt);
    }

    function burn(address usr, uint amt) external auth {
        balanceOf[usr] -= amt;
        totalSupply    -= amt;
        emit Transfer(usr, address(0), amt);
    }

    // --- erc20 ---

    function transfer(address dst, uint amt) public returns (bool) {
        return transferFrom(msg.sender, dst, amt);
    }

    function transferFrom(address src, address dst, uint amt) public returns (bool) {
        require(balanceOf[src] >= amt, "token/insufficient-balance");
        if (src != msg.sender && allowance[src][msg.sender] != type(uint).max) {
            require(allowance[src][msg.sender] >= amt, "token/insufficient-allowance");
            allowance[src][msg.sender] -= amt;
        }
        balanceOf[src] -= amt;
        balanceOf[dst] += amt;
        emit Transfer(src, dst, amt);
        return true;
    }

    function approve(address usr, uint amt) public returns (bool) {
        allowance[msg.sender][usr] = amt;
        emit Approval(msg.sender, usr, amt);
        return true;
    }

    // --- permit ---

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external {
        require(deadline >= block.timestamp, "token/expired-permit");
        bytes32 digest = keccak256(
            abi.encodePacked(
                "\x19\x01",
                DOMAIN_SEPARATOR(),
                keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline))
            )
        );

        address recoveredAddress = ecrecover(digest, v, r, s);
        require(recoveredAddress != address(0) && recoveredAddress == owner, "token/invalid-signature");

        allowance[owner][spender] = value;
        emit Approval(owner, spender, value);
    }

    function DOMAIN_SEPARATOR() public view returns (bytes32) {
        bytes32 domainTypehash = keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)");
        return keccak256(abi.encode(domainTypehash, keccak256(bytes(name)), keccak256(bytes("1")), block.chainid, address(this)));
    }
}
