pragma solidity ^0.8.0;

library RaribleStructs{
    struct AssetType {
        bytes4 assetClass;
        bytes data;
    }

    struct Asset {
        AssetType assetType;
        uint value;
    }

    struct Order {
        address maker;
        Asset makeAsset;
        address taker;
        Asset takeAsset;
        bytes salt;
        uint start;
        uint end;
        bytes4 dataType;
        bytes data;
    }

    struct Part {
        address payable account;
        uint96 value;
    }

    struct DataV1 {
        Part[] payouts;
        Part[] originFees;
    }
}


interface RaribleExchange {
    function matchOrders(
        RaribleStructs.Order memory orderLeft,
        bytes memory signatureLeft,
        RaribleStructs.Order memory orderRight,
        bytes32 signatureRight
    ) external payable;
}