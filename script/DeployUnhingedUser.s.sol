// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22;

import {Script, console} from "forge-std/Script.sol";
import {UpgradeableBeacon} from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";

import {UnhingedUser} from "../src/UnhingedUser.sol";
import {UnhingedUserFactory} from "../src/factory/UnhingedUserFactory.sol";

contract DeployUnhingedUser is Script {
    
    function run() public {
        // Get private key from environment
        uint256 deployerPrivateKey = vm.envUint("DEPLOYER_PRIV_KEY");
        address deployerAddress = vm.addr(deployerPrivateKey);
        
        // Get other parameters from environment or use defaults
        address adminAddress = vm.envOr("ADMIN_ADDRESS", deployerAddress);
        
        console.log("Deploying with deployer:", deployerAddress);
        console.log("Admin address:", adminAddress);
        
        vm.startBroadcast(deployerPrivateKey);
        
        // 1. Deploy UnhingedUser implementation
        console.log("Deploying UnhingedUser implementation...");
        UnhingedUser implementation = new UnhingedUser();
        console.log("UnhingedUser implementation deployed at:", address(implementation));
        
        // 2. Deploy UpgradeableBeacon pointing to implementation
        console.log("Deploying UpgradeableBeacon...");
        UpgradeableBeacon beacon = new UpgradeableBeacon(
            address(implementation),
            deployerAddress  // beacon owner who can upgrade
        );
        console.log("UpgradeableBeacon deployed at:", address(beacon));
        
        // 3. Deploy UnhingedUserFactory
        console.log("Deploying UnhingedUserFactory...");
        UnhingedUserFactory factory = new UnhingedUserFactory();
        console.log("UnhingedUserFactory deployed at:", address(factory));
        
        // 4. Initialize the factory
        console.log("Initializing UnhingedUserFactory...");
        factory.initialize(
            address(beacon),    // beacon address
            deployerAddress,    // factory owner
            adminAddress        // admin address for user contracts
        );
        console.log("UnhingedUserFactory initialized successfully");
        
        vm.stopBroadcast();
        
        // Log deployment summary
        console.log("\n=== DEPLOYMENT SUMMARY ===");
        console.log("UnhingedUser Implementation:", address(implementation));
        console.log("UpgradeableBeacon:", address(beacon));
        console.log("UnhingedUserFactory:", address(factory));
        console.log("Factory Owner:", deployerAddress);
        console.log("Admin Address:", adminAddress);
        console.log("\n=== NEXT STEPS ===");
        console.log("Your backend can now call factory.onboardUser() to create new user contracts");
        console.log("Factory address for your backend:", address(factory));
    }
}