// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.4;
import {Auth} from "./auth.sol";

contract Proxy is Auth {

    // --- data ---

    bytes32 constant salt = bytes32("acab");
    Builder immutable builder;

    // --- logs ---

    event Execute(address target, bytes data);

    // --- init ---

    constructor(address usr, address builder_)
        Auth(usr)
    {
        builder = Builder(builder_);
    }

    // --- exec ---

    function execute(bytes memory code, bytes calldata data)
        external
        payable
        returns (address usr, bytes memory out)
    {
        usr = create2Address(code);

        uint size;
        assembly { size := extcodesize(usr) }
        if (size == 0) builder.build(code);

        out = execute(usr, data);
    }

    function execute(address usr, bytes memory data)
        public
        auth
        payable
        returns (bytes memory out)
    {
        bool ok;
        (ok, out) = usr.delegatecall(data);
        require(ok, "proxy/delegatecall-error");

        emit Execute(usr, data);
    }

    // --- util ---

    function create2Address(bytes memory code) internal view returns (address) {
        return address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(builder),
            builder.salt(),
            keccak256(code)
        )))));
    }

    receive() external payable {}
}

contract ProxyFactory {
    Builder immutable builder = new Builder();

    function build(address usr) external returns (address) {
        return address(new Proxy(usr, address(builder)));
    }
}

contract Builder {
    bytes32 public constant salt = bytes32("acab");

    function build(bytes memory code) external returns (address usr) {
        uint salt_ = uint(salt);
        uint size;

        assembly {
            usr := create2(0, add(code, 0x20), mload(code), salt_)
            size := extcodesize(usr)
        }
        require(size > 0, "builder/deployment-failed");
    }
}
