require("@nomiclabs/hardhat-ethers");
require("dotenv").config();
const Web3 = require('web3');
require("@nomiclabs/hardhat-ethers");
require("dotenv").config();
const { task } = require("hardhat/config");
const {
  API_URL_GOERLI,
  API_URL_MUMBAI,
  API_URL_ARBITRUM,
  API_URL_OPTIMISM,
  PRIVATE_KEY,
} = process.env;

task("account", "returns nonce and balance for specified address on multiple networks")
  .addParam("address")
  .setAction(async address => {
    const web3Goerli = new Web3(API_URL_GOERLI);
    const web3Mumbai =new Web3(API_URL_MUMBAI);
    const web3bsc = new Web3(API_URL_ARBITRUM);
    const web3fan = new Web3(API_URL_OPTIMISM);
   


    const networkIDArr = ["Goreli:", "mumbai:"]
    const providerArr = [web3Goerli, web3Mumbai];
    const resultArr = [];
    
    for (let i = 0; i < providerArr.length; i++) {
      const nonce = await providerArr[i].eth.getTransactionCount(address.address, "latest");
      const balance = await providerArr[i].eth.getBalance(address.address)
      resultArr.push([networkIDArr[i], nonce, parseFloat(providerArr[i].utils.fromWei(balance, "ether")).toFixed(2) + "ETH"]);
    }

    resultArr.unshift(["  |NETWORK|   |NONCE|   |BALANCE|  "])
    console.log(resultArr);
  });
module.exports = {
  solidity: "0.8.9",
  networks: {
    hardhat: {},
    goerli: {
      url: API_URL_GOERLI,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    mumbai: {
      url: API_URL_MUMBAI,
      accounts: [`0x${PRIVATE_KEY}`],
    
    }

  },
};
