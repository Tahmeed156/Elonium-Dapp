// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract Lori is ERC721, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;
    address public elmAddress;
    uint256 public elmPerNft;

    constructor(address _elmAddress, uint256 _elmPerNft) ERC721("Lori", "LORI") {
        elmAddress = _elmAddress;
        elmPerNft = _elmPerNft;
    }

    function safeMint() public {
        ERC20(elmAddress).transferFrom(msg.sender, address(this), elmPerNft * 1e18);

        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(msg.sender, tokenId);
    }
}