pragma solidity ^0.8.0;
import "./ShardToken.sol";
//import "../libs/RaribleLib.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract Phoenix {
    address private _owner;
    string private _name = "Phoenix Token Factory";
    address[] private _emissions;  // Is it fine to delete from array in Solidity? Maybe I should use map?
    mapping (address => uint) private _total_locked;
    mapping (address => mapping (address => uint)) private _locks;
//    RaribleExchange private _rarible_exchange;
//    function rarible_exchange() public returns(address) {
//        return address(_rarible_exchange);
//    }

    constructor() {
        _owner = msg.sender;
//        _rarible_exchange = RaribleExchange(0x1e1B6E13F0eB4C570628589e3c088BC92aD4dB45);
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

    // ToDo Make public
//    function rarible_make_order(address item_, uint id_, uint price_, address nft_owner_, bytes memory salt_,
//                                uint start_, uint end_, bytes4 dataType_, bytes memory signature_) public {
//        //    Eth Asset. ToDo move to rarible_make_order
//        RaribleStructs.Asset memory eth_asset = RaribleStructs.Asset(
//            RaribleStructs.AssetType(0xaaaebeba, "0x"),  // ETH
//            _total_locked[item_]
//        );
//        RaribleStructs.Asset memory erc721_asset = RaribleStructs.Asset(
//            RaribleStructs.AssetType(0x73ad2146, abi.encode(item_, id_)),  // ERC721
//            price_
//        );
//
//        RaribleStructs.Order memory order_left = RaribleStructs.Order(
//            nft_owner_,  // taker
//            erc721_asset,  // makeAsset
//            address(this),  // maker
//            eth_asset,  // takeAsset
//            salt_, start_, end_, dataType_,
//            "0x"
////            abi.encode(RaribleStructs.DataV1(RaribleStructs.Part[], RaribleStructs.Part[]))  // data
//        );
//
//        RaribleStructs.Order memory order_right = RaribleStructs.Order(  // buy order
//            address(this),  // maker
//            eth_asset,  // makeAsset
//            nft_owner_,  // taker
//            erc721_asset,  // takeAsset
//            bytes("adsfadsf"), 0, 0, 0x96690ee3,
//            "0x"
////            abi.encode(RaribleStructs.DataV1([RaribleStructs.Part[], RaribleStructs.Part[]]))  // daata
//        );
//        _rarible_exchange.matchOrders(order_left, signature_, order_right, keccak256(abi.encode(order_right)));
//    }

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

