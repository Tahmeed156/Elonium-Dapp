// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./ReceiverRestricted.sol";
import "./Mining.sol";

contract Elonium is ERC20, Ownable, ReceiverRestricted, Mining {

    uint256 public unitsPerCelo;

    constructor(uint256 _unitsPerCelo) ERC20("Elonium", "ELM") {
        _mint(msg.sender, 10000000 * 10 ** decimals());
        receivers.push(msg.sender);
        unitsPerCelo = _unitsPerCelo;
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }
    
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public override returns (bool) {
        require(receiverExists(to), "Elonium: not an eligible receiver");

        address spender = _msgSender();
        // Owner can freely transfer
        if (owner() != _msgSender())
            _spendAllowance(from, spender, amount);

        _transfer(from, to, amount);
        return true;
    }

    function transfer(address to, uint256 amount) public override returns (bool) {
        require(receiverExists(to), "Elonium: not an eligible receiver");

        address owner = _msgSender();
        _transfer(owner, to, amount);
        return true;
    }

    function burnAllTokens() public onlyOwner {

        // Iterate over all receivers and burn tokens individually 
        for (uint i = 0; i < receivers.length; i++) {
            uint256 amount = balanceOf(receivers[i]);
            _burn(receivers[i], amount);
        }

        // All tokens should be burned
        assert(totalSupply() == 0);
    }

    receive() external payable {
        uint256 amount = (msg.value * unitsPerCelo);
        require(balanceOf(owner()) >= amount, "Elonium: not enough tokens");
        _transfer(owner(), msg.sender, amount);

        emit Transfer(owner(), msg.sender, amount);
        
        // Send celo earned back to the owner
        payable(owner()).transfer(msg.value);
    }
}
