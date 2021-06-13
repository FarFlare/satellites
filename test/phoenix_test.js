require("chai")
    .use(require("chai-as-promised"))
    .should()

const Phoenix = artifacts.require("phoenix/Phoenix")
const ShardToken = artifacts.require("phoenix/ShardToken")


contract('Phoenix', ([deployer, item_to_own, investor1, investor2]) => {
    let phoenix = null

    before(async () => {
        phoenix = await Phoenix.new()
        id = 1
        item_price_eth = '0.05'
        item_price = web3.utils.toWei('0.05', 'ether')
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
            await phoenix.allocate(item_to_own, id, item_price, {from: investor1, value: web3.utils.toWei(share1, 'ether')})  // Get allocation for investor1
            assert.equal(await web3.eth.getBalance(phoenix.address), web3.utils.toWei(share1, 'ether'))  // Phoenix balance increased
            assert.equal(web3.utils.fromWei((await phoenix.locksFor(investor1, item_to_own, id)).toString()), share1)  // Lock for investor1 is correct

            await phoenix.allocate(item_to_own, id, item_price, {from: investor2, value: web3.utils.toWei(share2, 'ether')})  // Get allocation for investor2
            assert.equal(web3.utils.fromWei((await phoenix.locksFor(investor2, item_to_own, id)).toString()), share2)  // Lock for investor2 is correct
            assert.equal(web3.utils.fromWei((await phoenix.totalLockedFor(item_to_own, id)).toString()), parseFloat(share1)+parseFloat(share2))
        })

        it('Shares are correct', async () => {
            alloc1 = (await phoenix.getAllocation(item_to_own, id, {from: investor1}))[1].toString()
            assert.equal(alloc1, parseInt(share1*100/(parseFloat(share1)+parseFloat(share2))))
            alloc2 = (await phoenix.getAllocation(item_to_own, id, {from: investor2}))[1].toString()
            assert.equal(alloc2, parseInt(share2*100/(parseFloat(share1)+parseFloat(share2))))
        })

        it('Deallocating shares', async () => {
            await phoenix.deallocate(item_to_own, id, web3.utils.toWei((share1*2).toString(), 'ether'), {from: investor1}).should.be.rejected;
            await phoenix.deallocate(item_to_own, id, web3.utils.toWei((share1/2).toString(), 'ether'), {from: investor1})
            alloc1 = (await phoenix.getAllocation(item_to_own, id, {from: investor1}))[1].toString()
            alloc2 = (await phoenix.getAllocation(item_to_own, id, {from: investor2}))[1].toString()
            assert.equal(alloc1, parseInt(share1/2*100/(parseFloat(share1/2)+parseFloat(share2))))
            assert.equal(alloc2, parseInt(share2*100/(parseFloat(share1/2)+parseFloat(share2))))

            await phoenix.deallocate(item_to_own, id, web3.utils.toWei((share1/2).toString(), 'ether'), {from: investor1})
            alloc1 = (await phoenix.getAllocation(item_to_own, id, {from: investor1}))[1].toString()
            alloc2 = (await phoenix.getAllocation(item_to_own, id, {from: investor2}))[1].toString()
            assert.equal(alloc1, 0)
            assert.equal(alloc2, 100)
        })

        it('Emit Shards', async () => {
            // No Shards were produced
            assert.equal(await phoenix.shards(item_to_own, id), "0x0000000000000000000000000000000000000000")

            // Should trigger emission
            res = await phoenix.allocate(item_to_own, id, item_price, {from: investor1,
                                                                 value: web3.utils.toWei((parseFloat(item_price_eth)-parseFloat(share2)).toString(), 'ether')})
            alloc1 = (await phoenix.getAllocation(item_to_own, id, {from: investor1}))[0].toString()
            alloc2 = (await phoenix.getAllocation(item_to_own, id, {from: investor2}))[0].toString()
            assert.equal(alloc1, 0)
            assert.equal(alloc2, 0)
            assert.notEqual(await phoenix.shards(item_to_own, id), "0x0000000000000000000000000000000000000000")
            shards_address = await phoenix.shards(item_to_own, id)
            assert.equal((await phoenix.shattered(shards_address))[0], item_to_own)
            assert.equal((await phoenix.shattered(shards_address))[1], id)
        })

        it('Checks Shards distribution', async () => {
            // No Shards were produced
            shards_address = await phoenix.shards(item_to_own, id)
            shards = await ShardToken.at(shards_address)
            assert.equal(await shards.symbol(), "SHRD-FF")
            assert.equal((await shards.totalSupply()).toString().slice(0, -2), item_price.slice(0, -2))  // May be a small precision missmatch
            assert.equal((await shards.balanceOf(investor1)).toString().slice(0, -2), web3.utils.toWei((parseFloat(item_price_eth)-parseFloat(share2)).toString(), 'ether').slice(0, -2))  // May be a small precision missmatch
            assert.equal((await shards.balanceOf(investor2)).toString().slice(0, -2), web3.utils.toWei(share2).slice(0, -2))  // May be a small precision missmatch
        })
    })
})