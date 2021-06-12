// require("chai")
//     .use(require("chai-as-promised"))
//     .should()
//
// // https://github.com/rariblecom/protocol-contracts/blob/master/exchange-v2/contracts/ExchangeV2Core.sol
// // const rarible_abi = require("../external_abi/RaribleExchange.json")
// const Phoenix = artifacts.require("Phoenix")
// // const Test = artifacts.require("Test")
//
//
// contract('Interaction with Rarible', ([deployer, investor1, investor2]) => {
//     before(async () => {
//         // rari = new web3.eth.Contract(rarible_abi, "0x43162023c187662684abaf0b211dccb96fa4ed8a")
//         // test = await Test.new()
//         phoenix = await Phoenix.new()
//     })
//
//     describe("Encoding", async () => {
//         it('Checks encoding', async () => {
//             a = await phoenix.rarible_make_order("0x6ede7f3c26975aad32a475e1021d8f6f39c89d82", "29717585154687144884817730631809658487984116655369711026868430457829559631873",
//                                                  1, "0x41b38ea064b7ac475296b0e53c4b8c61a3ead83a", "0x0000000000000000000000000000000000000000000000000000000000001ca0",
//                                                  0, 0, "V1", "0xb81e09258bdb5b49b7b0d51a3b309c7c3da8464608b0d034e48c389a73e106794430b6368e9d5bfa60071eaad46ef9f853a6f2dbb811ef1804f3b5e6c86e40761b")
//             print(a)
//             assert.equals(1, 1)
//         })
//     })
// })