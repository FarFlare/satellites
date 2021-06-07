import requests
from pprint import pprint

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


def get_sell_orders():
    resp = requests.get(f"https://api-staging.rarible.com/protocol/v0.1/ethereum/order/orders/sell/byItem",
                        params={"contract": contract,
                                "tokenId": token_id})
    return resp.json()


if __name__ == '__main__':
    pprint(get_meta_by_id())
