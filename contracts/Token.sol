
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