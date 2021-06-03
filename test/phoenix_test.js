// const Phoenix = artifacts.require("Phoenix")
const RebirthToken = artifacts.require("RebirthToken")


contract('RebirthToken', ([deployer]) => {
    describe("Token Deployment", async () => {
        it('Checks deployment', async () => {
            const token = await RebirthToken.deployed()
            console.log(token.address())
            assert.equal(symbol, "PWN")
        })
    })
})