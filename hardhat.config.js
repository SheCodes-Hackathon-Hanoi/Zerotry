/* eslint-disable no-mixed-spaces-and-tabs */
/* eslint-disable no-undef */
require('dotenv').config();
require('@nomiclabs/hardhat-ethers');
const fs = require("fs")
const mnemonic = fs.readFileSync(".secret").toString().trim()


task("accounts", "Prints the list of accounts", async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.18",
    settings: {
      optimizer: {
        enabled: true
      }
     }
    },
  networks: {
  	
  	localhost: {
      url: "http://127.0.0.1:8545"
    },
    hardhat: {
    },
    testnet: {
      url: "https://data-seed-prebsc-1-s1.binance.org:8545",
      chainId: 97,
      gasPrice: 10000000000,
      accounts: {mnemonic: mnemonic}
    },
  },
  paths: {
    sources: "./contracts",
    tests: "./test",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  mocha: {
    timeout: 20000
  }
};
