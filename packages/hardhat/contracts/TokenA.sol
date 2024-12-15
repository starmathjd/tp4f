//https://sepolia.scrollscan.com/address/0x6255a0552540e5580f1828ead01064b79f375bcc
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity ^0.8.0;

contract TokenA is ERC20, Ownable {


    constructor() ERC20("TokenA", "TKA") Ownable(msg.sender) {
        _mint(msg.sender, 1000 * 10 ** decimals());  
    }


    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
} 
