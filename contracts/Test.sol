pragma solidity ^0.8.0;

contract Test {

    function encode() public pure returns (bytes memory){
        return abi.encode(address(0x6ede7F3c26975AAd32a475e1021D8F6F39c89d82),
                               uint(29717585154687144884817730631809658487984116655369711026868430457829559631873));
    }

}
