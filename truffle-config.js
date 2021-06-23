const HDWalletProvider = require('@truffle/hdwallet-provider');
const fs = require('fs');
const mnemonic = fs.readFileSync(".secret").toString().trim();

module.exports = {
    networks: {
      development: {
        host: "127.0.0.1",
        port: 8545,
        network_id: "*" // Match any network id
      },
      bscTestnet: {
          host: "",
          port: "",
          network_id: ,
          provider:
      }
    },
    compilers: {
      solc: {
        version: "^0.6.8"
      }
    }
  };