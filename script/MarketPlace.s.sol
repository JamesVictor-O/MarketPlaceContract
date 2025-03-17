// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {MarketPlace} from "../src/MarketPlace.sol";

contract CounterScript is Script {
   MarketPlace public counter;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        counter = new MarketPlace();

        vm.stopBroadcast();
    }
}
