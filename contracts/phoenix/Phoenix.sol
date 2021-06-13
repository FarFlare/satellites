pragma solidity ^0.8.0;
//  Rinkeby - '0xCBc6a221aB417FbDb316b7D06bcD74ec4d611638'
import "./ShardToken.sol";
//import "../libs/RaribleLib.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract Phoenix {
    address private _owner;
    string private _name = "Phoenix Token Factory";
    mapping (bytes => uint) private _total_locked;  // abi.encode(address item_address, uint item_id) => value_locked
    mapping (bytes => mapping (address => uint)) private _locks;  // abi.encode(address item_address, uint item_id) => investor => value

    mapping (bytes => address[]) private _participants;  // abi.encode(address item_address, uint item_id) => investor[]
    mapping (bytes => mapping (address => uint)) private _participants_index;  // abi.encode(address item_address, uint item_id) => investor_address => address_index

    mapping (bytes => address) private _shards;  // abi.encode(address item_address, uint item_id) => emission_address
    mapping (address => bytes) private _shattered;  // emission_address => abi.encode(address item_address, uint item_id)

//    event Allocation(address from, address item_address, uint item_id, uint item_price);
    event Shatter(address item_address, uint item_id);
    event ShardsTransaction(address who);

    constructor() {
        _owner = msg.sender;
    }

    function allocate(address item_address_, uint item_id_, uint item_price_) public payable {
        // With the new Rarible contract2contract API item_price_ should be get inside this func
        // In current realization some geeks can get over-allocation. This feature will be implemented in the next release, so it's fine
        bytes memory item_key = abi.encode(item_address_, item_id_);
        require(_shards[item_key] == address(0), "This has been already shattered");  // Do not let geeks pass item_price_ and bury their ETH
        if (_locks[item_key][msg.sender] == 0) {  // New participant
            _participants[item_key].push(msg.sender);
        }
        _total_locked[item_key] += msg.value;
        _locks[item_key][msg.sender] += msg.value;
        if(_total_locked[item_key] >= item_price_) {  // For now shouldn't be higher, but may be
            // ToDo Buy NFT via Rarible contract2contract. If success, then...
            emit Shatter(item_address_, item_id_);
            _spawn(item_key);
            _total_locked[item_key] = 0;
        }
    }

    // ToDo make deallocate for all. If the item was sold, we should transfer back ETH for investors and delete _participants
    function deallocate(address item_address_, uint item_id_, uint value) public {
        bytes memory item_key = abi.encode(item_address_, item_id_);

        require(_shards[item_key] == address(0), "This has been already shattered");
        require(_locks[item_key][msg.sender] >= value, "Swiper, No Swiping!");
        payable(msg.sender).transfer(value);
        _total_locked[item_key] -= value;
        _locks[item_key][msg.sender] -= value;
        if (_locks[item_key][msg.sender] == 0) {
            delete _participants[item_key][_participants_index[item_key][msg.sender]];
        }
    }

    // Get ETH in lock and % of total locks for msg.sender
    function getAllocation(address item_address_, uint item_id_) public view returns(uint, uint){
        bytes memory item_key = abi.encode(item_address_, item_id_);

        if (_total_locked[item_key] == 0) {
            return (0, 0);
        } else {
            return (_locks[item_key][msg.sender], _locks[item_key][msg.sender]*100/_total_locked[item_key]);
        }
    }

    // Get total locked ETH for the item
    function totalLockedFor(address item_address_, uint item_id_) public view returns(uint){
        bytes memory item_key = abi.encode(item_address_, item_id_);

        return _total_locked[item_key];
    }

    // For debug purposes only
    function locksFor(address shareholder_, address item_address_, uint item_id_) public view returns (uint){
        require(msg.sender == _owner);
        bytes memory item_key = abi.encode(item_address_, item_id_);
        return _locks[item_key][shareholder_];
    }

    // For debug purposes only
    function participantsFor(address item_address_, uint item_id_) public view returns (uint){
        bytes memory item_key = abi.encode(item_address_, item_id_);
        return _participants[item_key].length;
    }

    function shards(address item_address_, uint item_id_) public view returns (address){
        bytes memory item_key = abi.encode(item_address_, item_id_);
        return _shards[item_key];
    }

    function shattered(address shard_token_address_) public view returns (address, uint){
        return abi.decode(_shattered[shard_token_address_], (address, uint));
    }

    // Main function for creating and distributing new tokens
    function _spawn(bytes memory item_key_) private returns (bool) {
        ShardToken token = _newEmission("FarFlare", "FF", _total_locked[item_key_]);  // ToDo get NFT name?
        _shards[item_key_] = address(token);
        _shattered[address(token)] = item_key_;
        _distributeEmission(token, item_key_);  // Emission equals to total_locked of wei. ToDo Revise (too huge values?)
        return true;
    }

    function _newEmission(string memory name_postfix_, string memory symbol_postfix_, uint supply_) private returns (ShardToken) {
        string memory name = string(abi.encodePacked("Shard-", name_postfix_));
        string memory symbol = string(abi.encodePacked("SHRD-", symbol_postfix_));
        ShardToken procreation = new ShardToken(name, symbol, supply_);
        return procreation;
    }

    function _distributeEmission(ShardToken emission_, bytes memory item_key_) private {
        for (uint i = 0; i < _participants[item_key_].length; i++) {  // ToDo try to avoid cycle, support allocation via one transaction
            if (_locks[item_key_][_participants[item_key_][i]] > 0){  // If user didn't deallocate() to 0
                emission_.transfer(_participants[item_key_][i], _locks[item_key_][_participants[item_key_][i]]);
            }
        }
    }
}

