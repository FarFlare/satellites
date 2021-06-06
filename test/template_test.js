require("chai")
    .use(require("chai-as-promised"))
    .should()

const Phoenix = artifacts.require("Phoenix")
// const RebirthToken = artifacts.require("RebirthToken")


contract('Name', ([deployer, investor1, investor2]) => {
    let contract = null

    before(async () => {
        contract = await Phoenix.deployed()
    })

    describe("Deployment", async () => {
        it('Contract is deployed', async () => {
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