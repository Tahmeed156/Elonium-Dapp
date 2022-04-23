// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

abstract contract Mining is ERC20 {

    bytes32 private currentChallenge;
    uint private difficulty = 10**32;
    uint public timeOfLastProof;
    uint private lastBlockRewarded;


    function minePOW(uint nonce) public {
        
        // Generate a random hash and check if it passes
        bytes32 n = bytes32(keccak256(abi.encodePacked(nonce, currentChallenge)));
        require(n >= bytes32(difficulty), "Mining: invalid hash generated");

        // Ensure rewards are not given too quickly
        uint timeSinceLastProof = (block.timestamp - timeOfLastProof); 
        require(timeSinceLastProof >=  5 seconds); 
        
        // Prevent misuse e.g. attempting reward multiple times in same block
        require(lastBlockRewarded >= block.number, "Mining: not a new block number");
        lastBlockRewarded = block.number;

        // Reward given to the sender, increases with time taken
        uint256 reward = timeSinceLastProof / 60 seconds; 
        _mint(msg.sender, reward);

        // Adjusts the difficulty - if time increases then lower difficulty
        difficulty = difficulty * 10 minutes / timeSinceLastProof + 1;

        // Preparation for new proof
        timeOfLastProof = block.timestamp;
        currentChallenge = keccak256(abi.encodePacked(nonce, currentChallenge, blockhash(block.number - 1)));
    }

}