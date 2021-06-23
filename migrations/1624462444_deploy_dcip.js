const DCIP = artifacts.require("DCIP");

module.exports = function (deployer) {
  // Use deployer to state migration tasks.
  deployer.deploy(DCIP);
};