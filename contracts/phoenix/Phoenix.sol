pragma solidity ^0.8.0;
import "./RebirthToken.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract Phoenix {
    address private _owner;
    string private _name = "Phoenix Token Factory";
    address[] private _children;  // Is it fine to delete from array in Solidity? Maybe I should use map?
    mapping (address => mapping (address => uint)) private distributions;

    constructor() {
        _owner = msg.sender;
    }

    // Main function for creating and distributing new tokens
    function spawn() public returns (bool) {
        RebirthToken emission = new_emission("Test", "Tst");
        distribute_emission(emission);
        return true;
    }

    function new_emission(string memory name_postfix, string memory symbol_postfix) private returns (RebirthToken) {
        string memory name = string(abi.encodePacked("Creature ", name_postfix));
        string memory symbol = string(abi.encodePacked("Phnx", symbol_postfix));
        RebirthToken procreation = new RebirthToken(name, symbol, 100);
        _children.push(address(procreation));
        return procreation;
    }

    function distribute_emission(RebirthToken emission) private {
        emission.transfer(tx.origin, emission.totalSupply());
    }

    function children() public view returns (address[] memory){
        return _children;
    }
}

