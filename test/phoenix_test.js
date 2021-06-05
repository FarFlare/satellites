require("chai")
    .use(require("chai-as-promised"))
    .should()

const Phoenix = artifacts.require("Phoenix")
// const RebirthToken = artifacts.require("RebirthToken")


contract('Phoenix', ([deployer, item_to_own, investor1, investor2]) => {
    let phoenix = null

    before(async () => {
        phoenix = await Phoenix.deployed()
    })

    describe("Deployment", async () => {
        it('Contract is deployed', async () => {
            assert.notEqual(phoenix, null)
            console.log("\tPhoenix at: ", phoenix.address)
        })
    })

    describe("Participating in share pools", async () => {
        before(async () => {
            share1 = '0.01'
            share2 = '0.02'
        })

        it('Allocating of shares', async () => {
            await phoenix.allocate(item_to_own, {from: investor1, value: web3.utils.toWei(share1, 'ether')})  // Get allocation for investor1
            assert.equal(await web3.eth.getBalance(phoenix.address), web3.utils.toWei(share1, 'ether'))  // Phoenix balance increased
            assert.equal(web3.utils.fromWei((await phoenix.locksFor(investor1, item_to_own)).toString()), share1)  // Lock for investor1 is correct

            await phoenix.allocate(item_to_own, {from: investor2, value: web3.utils.toWei(share2, 'ether')})  // Get allocation for investor1
            assert.equal(web3.utils.fromWei((await phoenix.locksFor(investor2, item_to_own)).toString()), share2)  // Lock for investor2 is correct
        })

        it('Shares are correct', async () => {
            alloc1 = (await phoenix.getAllocation(item_to_own, {from: investor1}))[1].toString()
            assert.equal(alloc1, parseInt(share1*100/(parseFloat(share1)+parseFloat(share2))))
            alloc2 = (await phoenix.getAllocation(item_to_own, {from: investor2}))[1].toString()
            assert.equal(alloc2, parseInt(share2*100/(parseFloat(share1)+parseFloat(share2))))
        })

        it('Deallocating shares', async () => {
            await phoenix.deallocate(item_to_own, web3.utils.toWei((share1*2).toString(), 'ether'), {from: investor1}).should.be.rejected;
            await phoenix.deallocate(item_to_own, web3.utils.toWei((share1/2).toString(), 'ether'), {from: investor1})
            alloc1 = (await phoenix.getAllocation(item_to_own, {from: investor1}))[1].toString()
            alloc2 = (await phoenix.getAllocation(item_to_own, {from: investor2}))[1].toString()
            assert.equal(alloc1, parseInt(share1/2*100/(parseFloat(share1/2)+parseFloat(share2))))
            assert.equal(alloc2, parseInt(share2*100/(parseFloat(share1/2)+parseFloat(share2))))

            await phoenix.deallocate(item_to_own, web3.utils.toWei((share1/2).toString(), 'ether'), {from: investor1})
            alloc1 = (await phoenix.getAllocation(item_to_own, {from: investor1}))[1].toString()
            alloc2 = (await phoenix.getAllocation(item_to_own, {from: investor2}))[1].toString()
            assert.equal(alloc1, 0)
            assert.equal(alloc2, 100)
        })
    })
})