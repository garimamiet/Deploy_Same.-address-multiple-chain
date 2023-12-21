const { ethers, upgrades } = require("hardhat");
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
   