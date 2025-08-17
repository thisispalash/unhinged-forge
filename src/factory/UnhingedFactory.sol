// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UpgradeableBeacon} from "@openzeppelin/contracts/proxy/beacon/UpgradeableBeacon.sol";
import {BeaconProxy} from "@openzeppelin/contracts/proxy/beacon/BeaconProxy.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import {IUnhingedFactory} from "../_i/factory/IUnhingedFactory.sol";

/**
 * @title UnhingedFactory
 * @author @isthispalash
 * @notice Functions that manage the common factory functions
 */
contract UnhingedFactory is Initializable, OwnableUpgradeable, IUnhingedFactory {

    UpgradeableBeacon public beacon;
    address public admin;
    
    function initialize(address _beacon, address _owner, address _admin) external initializer {
        __Ownable_init(_owner);
        beacon = UpgradeableBeacon(_beacon);
        admin = _admin;
    }
    
    function updateBeacon(address _newBeacon) external onlyOwner {
        beacon.upgradeTo(address(_newBeacon));
    }

    function updateAdmin(address _newAdmin) external onlyOwner {
        admin = _newAdmin;
    }
}