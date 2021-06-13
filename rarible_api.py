import requests
from pprint import pprint
from random import randint
import json

contract = "0x6ede7f3c26975aad32a475e1021d8f6f39c89d82"
token_id = "29717585154687144884817730631809658487984116655369711026868430457829559631873"
itemId = f"{contract}:{token_id}"


def get_by_id():
    resp = requests.get(f"https://api-staging.rarible.com/protocol/v0.1/ethereum/nft/items/{itemId}")
    return resp.json()


def get_meta_by_id():
    resp = requests.get(f"https://api-staging.rarible.com/protocol/v0.1/ethereum/nft/items/{itemId}")
    return resp.json()


def get_all():
    resp = requests.get(f"https://api-staging.rarible.com/protocol/v0.1/ethereum/nft/items/all")
    return resp.json()


def get_sell_orders(by_item=False):
    if by_item:
        resp = requests.get(f"https://api-staging.rarible.com/protocol/v0.1/ethereum/order/orders/sell/byItem",
                            params={"contract": contract,
                                    "tokenId": token_id})
    else:
        resp = requests.get(f"https://api-staging.rarible.com/protocol/v0.1/ethereum/order/orders/sell",
                            params={
                                "sort": "LAST_UPDATE"
                            })
    return resp.json()


def get_bids():
    resp = requests.get(f"https://api-staging.rarible.com/protocol/v0.1/ethereum/order/orders/bids/byItem",
                        params={"contract": contract,
                                "tokenId": token_id})
    return resp.json()


def search_orders():
    # resp = requests.post(f"https://api-staging.rarible.com/protocol/v0.1/ethereum/order/indexer/orders/search",
    resp = requests.post(f"http://api-staging.rarible.com/protocol/ethereum/order/indexer/v1/orders/search",
                         data={"@type": "sell"})
    return resp.json()


def make_order():
    resp = requests.post(f"https://api-staging.rarible.com/protocol/v0.1/ethereum/order/orders",
                         data={
                             "type": "RARIBLE_V2",
                             "maker": "0x41B38Ea064B7ac475296B0e53c4b8C61A3EAd83a",
                             "make": {
                                 "assetType": {
                                     "assetClass": "ETH"
                                 },
                                 "value": "1000000000000000"
                             },
                             "taker": "0x6ede7f3c26975aad32a475e1021d8f6f39c89d82",
                             "take": {
                                 "assetType": {
                                     "assetClass": "ERC721_LAZY",
                                     "contract": "0x6ede7f3c26975aad32a475e1021d8f6f39c89d82",
                                     "creators": [
                                         {
                                             "account": "0x41b38ea064b7ac475296b0e53c4b8c61a3ead83a",
                                             "value": "10000"
                                         }
                                     ],
                                     "royalties": [],
                                     "signatures": [
                                         "0x3678af4f54ba38ddb318f4ea72d00ff474cc8be1495089bd66784f4c4696618441800132bef6bfc73dd23dcebf4bb3555cbea6a310b7016c106b7089c0878c021c"
                                     ],
                                     "tokenId": "29717585154687144884817730631809658487984116655369711026868430457829559631873",
                                     "uri": "/ipfs/QmWLsBu6nS4ovaHbGAXprD1qEssJu4r5taQfB74sCG51tp"
                                 },
                                 "value": "1"
                             },
                             "salt": 10001,
                             "data": {
                                 "dataType": "RARIBLE_V2_DATA_V1",
                                 "originFees": [],
                                 "payouts": []
                             }
                         })
    print(resp.json())


if __name__ == '__main__':
    pprint(make_order())
    # pprint(get_sell_orders(True))
    # pprint(get_bids())
