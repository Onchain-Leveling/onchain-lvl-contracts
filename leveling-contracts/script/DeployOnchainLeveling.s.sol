// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import "../src/contracts/OnchainLeveling.sol";

contract DeployOnchainLeveling is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        
        console.log("Deploying OnchainLeveling contract...");
        console.log("Deployer address:", deployer);
        console.log("Deployer balance:", deployer.balance);

        vm.startBroadcast(deployerPrivateKey);

        // Deploy OnchainLeveling contract with deployer as initial owner
        OnchainLeveling onchainLeveling = new OnchainLeveling(deployer);

        vm.stopBroadcast();

        console.log("OnchainLeveling deployed at:", address(onchainLeveling));
        console.log("Owner:", deployer);
        
        // Log the default tasks that were created
        console.log("\nDefault tasks created:");
        console.log("Task count:", onchainLeveling.taskDefCount());
        
        // Display task 1 (Running)
        (string memory name1, uint8 ttype1, uint16 goal1, uint16 xp1, bool enabled1) = onchainLeveling.getTaskDef(1);
        console.log("Task 1 - Name:", name1);
        console.log("Task 1 - Goal:", goal1, "XP:", xp1);
        console.log("Task 1 - Enabled:", enabled1);
        
        // Display task 2 (Walking)
        (string memory name2, uint8 ttype2, uint16 goal2, uint16 xp2, bool enabled2) = onchainLeveling.getTaskDef(2);
        console.log("Task 2 - Name:", name2);
        console.log("Task 2 - Goal:", goal2, "XP:", xp2);
        console.log("Task 2 - Enabled:", enabled2);
        
        // Display task 3 (Sit-ups)
        (string memory name3, uint8 ttype3, uint16 goal3, uint16 xp3, bool enabled3) = onchainLeveling.getTaskDef(3);
        console.log("Task 3 - Name:", name3);
        console.log("Task 3 - Goal:", goal3, "XP:", xp3);
        console.log("Task 3 - Enabled:", enabled3);
    }
}