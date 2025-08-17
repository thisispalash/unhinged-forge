// // Deploy UnhingedTake.sol (the actual implementation)
// UnhingedTake implementation = new UnhingedTake();

// // Deploy beacon pointing to implementation
// UpgradeableBeacon beacon = new UpgradeableBeacon(
//     address(implementation),
//     admin_address  // beacon owner who can upgrade
// );

// // Deploy factory with beacon address
// UnhingedUserFactory factory = new UnhingedUserFactory();
// factory.initialize(
//     address(beacon),
//     admin_address  // factory owner
// );

// // Admin calls this to deploy new user takes
// factory.onboardUser(
//     "username",
//     "initial take text", 
//     1, // template
//     user_address // owner of the take
// );

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22;

import {Script} from "forge-std/Script.sol";

contract DeployUnhingedUser is Script {

    function run() public {

    }

}