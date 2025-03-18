// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MarketPlace} from "../src/MarketPlace.sol";

contract CounterTest is Test {
    MarketPlace public  marketplace;
    address deployer=address(0xd65944287EB2685c345057F6a4A48d619bA6f7cf);
    uint256 dealerRegistrationFee = 1 ether;


    function setUp() public {
        vm.prank(deployer);
        marketplace  = new MarketPlace();
    }

    function test_DeployerIsOwner() public view{
        assertEq(marketplace.owner(), deployer,"Deployer should be the owner");
    }
    function test_registerDealer() public {
        vm.prank(deployer);
        vm.deal(deployer, dealerRegistrationFee);

       marketplace.registerDealer{value: dealerRegistrationFee}("dealer@example.com", "Dealer Name");
       (string memory email, string memory name, uint256 registrationTime, bool isActive) = marketplace.dealers(deployer);
        assertEq(email, "dealer@example.com", "Email should match");
        assertEq(name, "Dealer Name", "Name should match");
        assertTrue(isActive, "Dealer should be active");
        assertTrue(marketplace.isRegistered(deployer), "Dealer should be registered");
    }
}
