//https://sepolia.scrollscan.com/address/0x13ee382bc0cbadf3b2945542be62e286cfb3cf6e
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity ^0.8.0;

contract TokenB is ERC20, Ownable {


    constructor() ERC20("TokenB", "TKB") Ownable(msg.sender) {
        _mint(msg.sender, 1000 * 10 ** decimals());  
    }


    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
} 
