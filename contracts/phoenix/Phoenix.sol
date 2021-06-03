pragma solidity ^0.8.0;
import "./RebirthToken.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract Phoenix {
    address private _owner;
    string private _name = "Phoenix Token Factory";
    address[] private _children;  // Is it fine to delete from array in Solidity? Maybe I should use map?

    constructor() {
        _owner = msg.sender;
    }

    // Should be private and triggered by some other internal functions
    function spawn(string memory name_postfix, string memory symbol_postfix) public returns (address) {
        string memory name = string(abi.encodePacked("Creature ", name_postfix));
        string memory symbol = string(abi.encodePacked("Phnx", symbol_postfix));
        address procreation = address(new RebirthToken(name, symbol, 100));
        _children.push(procreation);
        return procreation;
    }

    function children() public view returns (address[] memory){
        return _children;
    }
}

