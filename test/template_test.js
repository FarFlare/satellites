require("chai")
    .use(require("chai-as-promised"))
    .should()

// https://github.com/rariblecom/protocol-contracts/blob/master/exchange-v2/contracts/ExchangeV2Core.sol
const rarible_abi = require("../external_abi/RaribleExchange.json")
// const RebirthToken = artifacts.require("RebirthToken")


contract('Interaction with Rarible', ([deployer, investor1, investor2]) => {
    let rari = null

    before(async () => {
        rari = new web3.eth.Contract(rarible_abi, "0x43162023c187662684abaf0b211dccb96fa4ed8a")
    })

    describe("Connections", async () => {
        it('Rarible is online', async () => {
            assert.notEqual(contract, null)
        })
    })

    describe("Some actions", async () => {
        before(async () => {
            a = '1'
        })

        it('Tests smth', async () => {

        })

    })
})