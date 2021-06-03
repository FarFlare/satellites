const Phoenix = artifacts.require("phoenix/Phoenix")
// const RebirthToken = artifacts.require("phoenix/RebirthToken")

module.exports = function (deployer) {
    deployer.deploy(Phoenix)
}