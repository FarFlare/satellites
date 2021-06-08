pragma solidity ^0.8.0;
import "../Libs/RaribleLib.sol";


contract HeyRarible {
    address private _owner;
    RaribleExchange rarible_exchange;

    constructor(address _rarible_exchange_address) {
        rarible_exchange = RaribleExchange(_rarible_exchange_address);
    }

    function ping() public returns (bool){
//        rarible_exchange.matchOrders()
        return true;
    }
}