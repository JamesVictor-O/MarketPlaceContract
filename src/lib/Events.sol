// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.26;

library Events{
    event CarMinted(address indexed seller, string indexed model, string name, uint256 price);
    event DealerRegistered(address indexed dealer, string name, uint256 timestamp);
     event CarSold(uint256 tokenId, address seller, address buyer, uint256 price);
}