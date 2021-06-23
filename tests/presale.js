const PrivateSaleDCIP = artifacts.require("PrivateSaleDCIP");

contract('Presale', (accounts) => {

    it("should set the DCIP rate to 750 on init", async () => {
        const instance = await PrivateSaleDCIP.deployed();
        const value = await instance.getName();

        assert.equal(value, 'my name');
    });
});