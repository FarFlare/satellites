const Phoenix = artifacts.require("phoenix/Phoenix")

module.exports = function (deployer) {
    deployer.deploy(Phoenix)
}