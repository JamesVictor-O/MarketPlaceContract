// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {MarketPlace} from "../src/MarketPlace.sol";

contract CounterTest is Test {
    event CarSold(
        uint256 indexed carId,
        address indexed seller,
        address indexed buyer,
        uint256 price
    );

    struct CarInfo {
        string make;
        string model;
        uint256 year;
        string vin;
        uint256 price;
        address dealer;
        bool forSale;
    }
    MarketPlace public marketplace;
    address deployer = address(0xd65944287EB2685c345057F6a4A48d619bA6f7cf);
    uint256 dealerRegistrationFee = 1 ether;
    address buyer = address(0x456);
    uint256 platformFee = 0.1 ether;

    function setUp() public {
        vm.prank(deployer);
        marketplace = new MarketPlace();
        vm.deal(deployer, 100 ether);
        vm.deal(buyer, 100 ether);
    }

    function test_DeployerIsOwner() public view {
        assertEq(marketplace.owner(), deployer, "Deployer should be the owner");
    }

    function test_registerDealer() public {
        vm.prank(deployer);
        vm.deal(deployer, dealerRegistrationFee);

        marketplace.registerDealer{value: dealerRegistrationFee}(
            "dealer@example.com",
            "James"
        );
        (string memory email, string memory name, , bool isActive) = marketplace
            .dealers(deployer);
        assertEq(email, "dealer@example.com", "Email should match");
        assertEq(name, "James", "Name should match");
        assertTrue(isActive, "Dealer should be active");
        assertTrue(
            marketplace.isRegistered(deployer),
            "Dealer should be registered"
        );
    }

    function test_mintNft() public {
        vm.prank(deployer);
        vm.deal(deployer, dealerRegistrationFee);
        marketplace.registerDealer{value: dealerRegistrationFee}(
            "dealer@example.com",
            "James"
        );
        vm.prank(deployer);
        marketplace.mintNft(
            "tesla",
            "2016",
            2015,
            "0345673",
            1 ether,
            "ffkkfjfjf"
        );
        (, , , , , uint256 price, , bool isAvailable) = marketplace.carById(1);
        assertEq(price, 1 ether);
        assertEq(isAvailable, false);
    }

    function test_listCar() public {
        vm.prank(deployer);
        vm.deal(deployer, dealerRegistrationFee);
        marketplace.registerDealer{value: dealerRegistrationFee}(
            "dealer@example.com",
            "James"
        );
        vm.prank(deployer);
        marketplace.mintNft(
            "tesla",
            "2016",
            2015,
            "0345673",
            1 ether,
            "ffkkfjfjf"
        );

        vm.prank(deployer);
        marketplace.listCar(1, 2 ether);
        (,, , , , uint256 price, , bool isAvailable) = marketplace.carById(1);
        assertEq(isAvailable, true);
        assertEq(price, 2 ether);
    }

    function _registerDealerAndMintCar() internal returns (uint256 carId) {
        vm.prank(deployer);
        marketplace.registerDealer{value: dealerRegistrationFee}(
            "dealer@example.com",
            "James"
        );

        // Mint a car
        vm.prank(deployer);
        carId = marketplace.mintNft(
            "tesla",
            "model3",
            2015,
            "0345673",
            1 ether,
            "ffkkfjfjf"
        );
    }

    function test_buyCar_success() public {
        uint256 carId = _registerDealerAndMintCar();

        // List the car for sale
        vm.prank(deployer);
        marketplace.updateCarPrice(carId, 1 ether);

        // Buy the car
        uint256 totalCost = 1 ether + platformFee;

        // Expect the CarSold event
        emit CarSold(carId, deployer, buyer, 1 ether);
        vm.prank(deployer);
        marketplace.listCar(1, 1 ether);

        vm.prank(buyer);
        marketplace.buyCar{value: totalCost}(carId);

        // Verify state changes
        (,, , , , uint256 price, address dealer, bool forSale) = marketplace
            .carById(carId);
        assertEq(price, 1 ether, "Price should remain unchanged");
        assertEq(dealer, buyer, "Buyer should be the new dealer");
        assertFalse(forSale, "Car should no longer be for sale");

        // Verify ownership transfer
        address owner = marketplace.ownerOf(carId);
        assertEq(owner, buyer, "Buyer should own the car");

        // Verify carBought array
        MarketPlace.CarInfo[] memory carsBought = marketplace.getAllCarsBought(
            buyer
        );
        assertEq(carsBought.length, 1, "Buyer should have 1 car bought");
        assertEq(carsBought[0].make, "tesla", "Car make should match");
    }

    function test_buyCar_notListed() public {
        uint256 carId = _registerDealerAndMintCar();
        vm.prank(buyer);
        vm.expectRevert("Car not Listed");
        marketplace.buyCar{value: 1 ether + platformFee}(carId);
    }

    function test_updateCarPrice() public {
        uint256 carId = _registerDealerAndMintCar();

        vm.prank(deployer);
        marketplace.updateCarPrice(carId, 2 ether);

        (, , , , , uint256 price, , ) = marketplace.carById(carId);
        assertEq(price, 2 ether, "Price should be updated to 2 ether");
    }

    function test_updateCarPrice_nonOwner() public {
        uint256 carId = _registerDealerAndMintCar();

        vm.prank(buyer);
        vm.expectRevert("Not the car owner");
        marketplace.updateCarPrice(carId, 2 ether);
    }

    function test_getAllCarsBought() public {
        uint256 carId = _registerDealerAndMintCar();

        vm.prank(deployer);
        marketplace.listCar(1, 1 ether);

        // Buy the car
        uint256 totalCost = 1 ether + platformFee;
        vm.prank(buyer);
        marketplace.buyCar{value: totalCost}(1);

        // Verify the cars bought by the buyer
        MarketPlace.CarInfo[] memory carsBought = marketplace.getAllCarsBought(
            buyer
        );
        assertEq(carsBought.length, 1, "Buyer should have 1 car bought");
        assertEq(carsBought[0].make, "tesla", "Car make should match");
    }

    function test_getDealerCars() public {
        uint256 carId = _registerDealerAndMintCar();
       MarketPlace.CarInfo[] memory dealerCars = marketplace.getDealerCars(deployer);
        assertEq(dealerCars.length, 1, "Dealer should have 1 car");
    }
}

