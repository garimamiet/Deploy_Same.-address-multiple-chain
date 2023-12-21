
# How to Deploy a Contract to the Same Address on Multiple Networks

When you deploy a smart contract to the Ethereum network, the address is derived from your wallet address, the wallet's transaction count (i.e., the nonce), and your contract's bytecode. This ensures that each contract deployed to Ethereum has a unique address.

However, perhaps you want to deploy your contract across multiple networks with the same address. For example, you might want to deploy on Ethereum, Polygon, and Optimism with the same address. This can be useful for testing purposes and helpful to users interacting with your addresses across various networks. To do this, you must ensure your wallet's nonce is equivalent on each network, as illustrated below:



Configure your MetaMask wallet
Because we need our wallet's nonce to be the same across all networks, we advise configuring a new Metamask wallet to ensure no transactions have occurred. There are two ways to go about this:

### Option 1: `Create an Account`

### Option 2: `Import an Account`

When you create an account in MetaMask there is no way to delete it from your wallet. Therefore, if you want to later remove the account use the import account


## Option 1: Create an Account
To create a new wallet address, open MetaMask, click your profile icon > Create Account, set a name and create a new account:

If you want to remove the account later, you can use the method in Option 2 and Import Account instead.


##3 Option 2: Import an Account

You can generate a random private key to import into MetaMask using Node.js. In your terminal, start Node.js with the following command:


```shell
node
```

Then paste the following into your terminal to generate the key:

```shell
crypto.randomBytes(32, (_, bytes) => console.log(bytes.toString("hex")))
```

In your terminal, you should see an output of a randomly generated private key, similar to the following:

```shell
4b04aae9fd5bf113413ad8d98ede6b48a7884313edd046f25b77ac696d61f4d1
```

## Setup project environment

Open VS Code (or your preferred IDE) and enter the following in terminal:

```shell
mkdir deploy-demo
cd deploy-demo
```

Once inside our project directory, create the following two directories:

```shell
mkdir contracts
mkdir scripts
```


The contracts folder will store our project smart contracts and the scripts folder will contain our deployment and interaction scripts.

Next, initialize npm (node package manager) with the following command:

```shell
npm init
```
Press enter and answer the project prompt as follows:

```json
package name: (Deterministic-deploy-factory)
version: (1.0.0)
description: 
entry point: (index.js)
test command: 
git repository: 
keywords: 
author: 
license: (ISC)
```

Press enter again to complete the prompt. If successful, a package.json file will have been created in your directory.


## Install Hardhat

Hardhat is a development environment that allows us to interact, test, and deploy our contracts within one environment.

To install Hardhat, type the following in terminal:

```shell
npm install --save-dev hardhat
```

Once Hardhat is installed create a new project by typing the following command:

```shell
npx hardhat
```

```shell
888    888                      888 888               888
888    888                      888 888               888
888    888                      888 888               888
8888888888  8888b.  888d888 .d88888 88888b.   8888b.  888888
888    888     "88b 888P"  d88" 888 888 "88b     "88b 888
888    888 .d888888 888    888  888 888  888 .d888888 888
888    888 888  888 888    Y88b 888 888  888 888  888 Y88b.
888    888 "Y888888 888     "Y88888 888  888 "Y888888  "Y888

Welcome to Hardhat v2.10.1

? What do you want to do? ...      
  Create a JavaScript project      
  Create a TypeScript project      
> Create an empty hardhat.config.js
  Quit
```


Select Create an empty hardhat.config.js. Nice work! With Hardhat installed, we are nearly ready to start coding!


## Install environment tools


The tools you will need to complete this tutorial are:

[hardhat-ethers](https://hardhat.org/hardhat-runner/plugins/nomicfoundation-hardhat-ethers). (A Hardhat plugin that allows us to use the Ethers.js library)

[Web3.js](https://web3js.readthedocs.io/en/v1.10.0/)

[dotenv](https://www.npmjs.com/package/dotenv) (so that you can store your private key and API key safely)

To install the above tools, ensure you are still inside your root folder and type the following commands in terminal:

 ### Hardhat Ethers:
Shell

npm install npm install --save-dev @nomiclabs/hardhat-ethers 'ethers@^5.0.0'
### Web3:

```shell
npm install web3
```

### Dotenv:

```shell
npm install dotenv --save
```

Above, we have imported the libraries that we installed and all of the necessary variables to interact with `.env`

### Create a Dotenv File

Create an `.env` file in your root folder. The file must be named `.env` or it will not be recognized.

In the `.env` file, we will store all of our sensitive information (i.e. like MetaMask private key).

Copy the following into your `.env`

```.env

API_URL_GOERLI = "{GOERLI_RPC}"
API_URL_MUMBAI = "{MUMBAI_RPC}"
API_URL_ARBITRUM = "{ARB-GOERLI_RPC}"
API_URL_OPTIMISM = "{OPT-GOERLI_RPC}"
PRIVATE_KEY = "{YOUR_PRIVATE_KEY}"

```

Replace `{YOUR_RPC_URL}` with the respective network rpc url

## you can get rpc urls from [chainlist](https://chainlist.org/) 

Replace `{YOUR_PRIVATE_KEY}`with your MetaMask private key.


To retrieve your MetaMask private key:

Open the extension, click on the three dots menu, and choose Account Details. Then click Export Private Key:

### Edit hardhat.config.js

Add the following statements to the top of your `hardhat.config.js` file to process your `.env` file:

```hardhat.config.js

require("@nomiclabs/hardhat-ethers");
require("dotenv").config();
const { Web3 } = require("web3");
const { task } = require("hardhat/config");
const {
  API_URL_GOERLI,
  API_URL_MUMBAI,
  API_URL_ARBITRUM,
  API_URL_OPTIMISM,
  PRIVATE_KEY,
} = process.env;

```

Lastly, let's update the hardhat.config.js file so that we can interact with our API keys and private keys. Add the following networks inside the modules.exports object:


```hardhat.config.js

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
    },
    arbitrum: {
      url: API_URL_ARBITRUM,
      accounts: [`0x${PRIVATE_KEY}`],
    },
    optimism: {
      url: API_URL_OPTIMISM,
      accounts: [`0x${PRIVATE_KEY}`],
    },
  },
};

```

Now that we are finished setting up our Hardhat environment, we can create and deploy some contracts deterministically!

### Deterministic deployment setup

In this section of the guide, we will first set up a Hardhat task to query our wallet's nonce so we can be certain our contract will deploy to the same address on each network. Next, we will create a smart contract and deploy it using a deploy script.

### Create a Hardhat task to query the nonce

Hardhat tasks allow us to automate certain processes within the project environment. Because we need to be sure the nonce is identical across all networks, we will create a task that will return the nonce of each network. Additionally, let's include our wallet balance to ensure we have enough funds to deploy.

Inside your `hardhat.config.js` file, add the following task above `module.exports`:



```hardhat.config.js

const web3Goerli = Web3(API_URL_GOERLI);
const web3Mumbai = Web3(API_URL_MUMBAI);
const web3Arb = Web3(API_URL_ARBITRUM);
const web3Opt = Web3(API_URL_OPTIMISM);

```

Also within the async function, add a network ID array, provider array, and empty result array:

```hardhat.config.js

const networkIDArr = ["Ethereum Goerli:", "Polygon  Mumbai:", "Arbitrum Rinkby:", "Optimism Goerli:"]
const providerArr = [web3Goerli, web3Mumbai, web3Arb, web3Opt];
const resultArr = [];

```

Lastly, create a for loop to push our requested nonce and balance into the empty result array and print the results to console:


```hardhat.config.js

for (let i = 0; i < providerArr.length; i++) {
  const nonce = await providerArr[i].eth.getTransactionCount(address.address, "latest");
  const balance = await providerArr[i].eth.getBalance(address.address)
  resultArr.push([networkIDArr[i], nonce, parseFloat(providerArr[i].utils.fromWei(balance, "ether")).toFixed(2) + "ETH"]);
}
resultArr.unshift(["  |NETWORK|   |NONCE|   |BALANCE|  "])
console.log(resultArr);

```

Your completed task should look like this:

```hardhat.config.js

task("account", "returns nonce and balance for specified address on multiple networks")
  .addParam("address")
  .setAction(async address => {
    const web3Goerli = Web3(API_URL_GOERLI);
    const web3Mumbai = Web3(API_URL_MUMBAI);
    const web3Arb = Web3(API_URL_ARBITRUM);
    const web3Opt = Web3(API_URL_OPTIMISM);

    const networkIDArr = ["Ethereum Goerli:", "Polygon  Mumbai:", "Arbitrum Rinkby:", "Optimism Goerli:"]
    const providerArr = [web3Goerli, web3Mumbai, web3Arb, web3Opt];
    const resultArr = [];
    
    for (let i = 0; i < providerArr.length; i++) {
      const nonce = await providerArr[i].eth.getTransactionCount(address.address, "latest");
      const balance = await providerArr[i].eth.getBalance(address.address)
      resultArr.push([networkIDArr[i], nonce, parseFloat(providerArr[i].utils.fromWei(balance, "ether")).toFixed(2) + "ETH"]);
    }
    resultArr.unshift(["  |NETWORK|   |NONCE|   |BALANCE|  "])
    console.log(resultArr);
  });

```

Now let's run our task with the following:

```shell
npx hardhat account --address {YOUR_WALLET_ADDRESS}
```
If successful, you should see this result:

```shell
[
  [ '  |NETWORK|   |NONCE|   |BALANCE|  ' ],
  [ 'Ethereum Goerli:', 1, '1.47ETH' ],
  [ 'Polygon  Mumbai:', 1, '9.99ETH' ],
  [ 'Arbitrum Rinkby:', 1, '1.49ETH' ],
  [ 'Optimism Goerli:', 1, '2.26ETH' ]
]
```

With the necessary setup complete, let's create and deploy a contract.

# Create Token contract

For this tutorial, we will create a Token where funds can be deposited and withdrawn by the owner only after a specified period of time. However, feel free to deploy any contract you would like!

In your contracts folder, create a new solidity file named `Token.sol` and add the following lines of code:


```Token.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract Token is ERC20 , Ownable{

    uint256 private constant TotalSupply = 100000000;//100 million
    uint256 public constant percentageDivider = 10000; //100%
    uint256 public constant Private = 200; //2%
    uint256 public constant Pre_Seed = 300; //3%
    uint256 public constant Seed = 500; //5%
    uint256 public constant Ico = 1800; //18%
    uint256 public constant Public_sale = 1200; //12%
    uint256 public constant Founders = 2000; //20%
    uint256 public constant Core_Team = 500; //5%
    uint256 public constant Advisors = 300; //3%
    uint256 public constant Comapany_reserve = 2000; //20%
    uint256 public constant Charity = 200; //2%
    uint256 public constant Marketing = 1000; //10%
  
    uint256 public Private_Token;
    uint256 public Pre_Seed_Tokens;
    uint256 public Seed_token;
    uint256 public Ico_Token;
    uint256 public Public_Token;
    uint256 public Founders_Token;
    uint256 public Core_Team_Toekn;
    uint256 public Advisors_Tokens;
    uint256 public Comapany_reserve_Token;
    uint256 public Charity_Token;
    uint256 public Marketing_Token;
    
    


    constructor() ERC20("Token", "T")  {
        Private_Token = (TotalSupply*(Private))/(percentageDivider);
        Pre_Seed_Tokens = (TotalSupply*(Pre_Seed))/(percentageDivider);
        Seed_token = (TotalSupply*(Seed))/(percentageDivider);
        Ico_Token = (TotalSupply*(Ico))/(percentageDivider);
        Core_Team_Toekn = (TotalSupply*(Core_Team))/(percentageDivider);
        Public_Token = (TotalSupply*(Public_sale))/(percentageDivider);
        Founders_Token = (TotalSupply*(Founders))/(percentageDivider);
        Advisors_Tokens = (TotalSupply*(Advisors))/(percentageDivider);
        Comapany_reserve_Token = (TotalSupply*(Comapany_reserve))/(percentageDivider);
        Charity_Token = (TotalSupply*(Charity))/(percentageDivider);
        Marketing_Token = (TotalSupply*(Marketing))/(percentageDivider);
    }

    receive() external payable {
        payable(owner()).transfer(msg.value);
    }

    function fallabck() public payable {
        payable(owner()).transfer(getBalance());
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function mint(address account, uint256 amount) external onlyOwner{
        _mint(account, amount);
    }
}
```

Awesome! Our Token contract is complete. Before we move on to writing the deployment script, let's compile the contract by typing the following in the terminal:

```shell
npx hardhat compile
```

If successful, Hardhat will return:


```shell
Compiled 1 Solidity file successfully

```

```shell

const main = async () => {

 const [deployer] = await ethers.getSigners();
  try {
    const Token = await ethers.getContractFactory("Token");
    const token = await Token.deploy();
  
    console.log("Contract address",token.address);
  } catch (error) {
    console.log(error);
  }

};

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

```

run the deploy script for each network with this Hardhat command:


```shell
npx hardhat run scripts/deploy.js --network goerli
npx hardhat run scripts/deploy.js --network mumbai
npx hardhat run scripts/deploy.js --network arbitrum
npx hardhat run scripts/deploy.js --network optimism

```

If successful, your Token contract will deploy on each testnet to the same address:

```shell
Deployed to: 0xd216001476CC8F8a277F45d9bFE3996c3f38da5a
Deployed to: 0xd216001476CC8F8a277F45d9bFE3996c3f38da5a
Deployed to: 0xd216001476CC8F8a277F45d9bFE3996c3f38da5a
Deployed to: 0xd216001476CC8F8a277F45d9bFE3996c3f38da5a

```

To check our transactions on blockchain explorer

[goreli](https://goerli.etherscan.io/),
[mumbai](https://mumbai.polygonscan.com/),
[arbitrum](https://testnet.arbiscan.io/),
[optimism](https://optimistic.etherscan.io/),

