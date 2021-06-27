var myContract = artifacts.require("DCIP");

var testNetwork = {
    routerAddress: "0x6725F303b657a9451d8BA641348b6761A6CC7a17", // Pancakeswap
    marketingWalletAddress: "0xDCDb52F336Ed4E0577F2Ab6b298269aaf20A1EC1", // Account 1 of Rick
    communityAddress: "0xd3EaF9906a4FeE2d4334044559DF0579Fa65F253"
};

module.exports = function (deployer) {

    // Deployment steps
    deployer.deploy(myContract, testNetwork.routerAddress, testNetwork.marketingWalletAddress, testNetwork.communityAddress);
}