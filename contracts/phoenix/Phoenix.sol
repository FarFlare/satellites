pragma solidity ^0.8.0;
import "./ShardToken.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract Phoenix {
    address private _owner;
    string private _name = "Phoenix Token Factory";
    address[] private _emissions;  // Is it fine to delete from array in Solidity? Maybe I should use map?
    mapping (address => uint) private _total_locked;
    mapping (address => mapping (address => uint)) private _locks;

    constructor() {
        _owner = msg.sender;
    }

    function allocate(address item_) public payable {
        // ToDo check msg.value is not higher than item price
        _total_locked[item_] += msg.value;
        _locks[item_][msg.sender] += msg.value;
    }

    function deallocate(address item_, uint value) public {
        require(_locks[item_][msg.sender] >= value, "You can't deallocate more share than you have!");
        payable(msg.sender).transfer(value);
        _total_locked[item_] -= value;
        _locks[item_][msg.sender] -= value;
    }

    function getAllocation(address item_) public view returns (uint, uint){
        if (_total_locked[item_] == 0) {
            return (0, 0);
        } else {
            return (_locks[item_][msg.sender], _locks[item_][msg.sender]*100/_total_locked[item_]);
        }
    }

    // For debug purposes
    function locksFor(address shareholder, address item) public view returns (uint){
        require(msg.sender == _owner);
        return _locks[item][shareholder];
    }

    // Main function for creating and distributing new tokens
    function _spawn() private returns (bool) {
        ShardToken token = _newEmission("Test", "Tst");
        _distributeEmission(token);
        return true;
    }

    function _newEmission(string memory name_postfix, string memory symbol_postfix) private returns (ShardToken) {
        string memory name = string(abi.encodePacked("Creature ", name_postfix));
        string memory symbol = string(abi.encodePacked("Phnx", symbol_postfix));
        ShardToken procreation = new ShardToken(name, symbol, 100);
        _emissions.push(address(procreation));
        return procreation;
    }

    function _distributeEmission(ShardToken emission) private {
        emission.transfer(tx.origin, emission.totalSupply());
    }
}

