const Presale = artifacts.require("Presale");

contract("Presale", accounts => {
    it("should set the DCIP rate to 750 on init", () => {
        Presale.deployed()
            .then(instance => assert.equal(instance.rate.valueOf(), 750, "The rate wasn't 750"))
    })
})