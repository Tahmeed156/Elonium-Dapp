// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract ReceiverRestricted is ERC20, Ownable {

    // List of eligible receivers, specified/modified by owner
    address[] public receivers;

    // TODO: only to those addresses
    // TODO: define event 

    function addReceiver(address _recv) public onlyOwner {
        require(_recv != address(0), "Elonium: can't add zero address");
        require(!receiverExists(_recv), "Elonium: address already exists");

        receivers.push(_recv);
    }

    function removeReceiver(address _recv) public onlyOwner {
        require(_recv != address(0), "Elonium: can't remove zero address");
        require(receiverExists(_recv), "Elonium: address does not exist");

        delete receivers[uint(getReceiverIndex(_recv))];
    }

    function receiverExists(address _recv) public view returns(bool) {
        return getReceiverIndex(_recv) != -1;
    }

    function getReceiverIndex(address _recv) public view returns(int) {
        for (uint i = 0; i < receivers.length; i++)
            if (receivers[i] == _recv)
                return int(i);
        return -1;
    }
}