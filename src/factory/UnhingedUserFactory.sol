// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {IUnhingedTake} from "../_i/user/IUnhingedTake.sol";

import {UnhingedFactory, BeaconProxy} from "./UnhingedFactory.sol";
import {IUnhingedUserFactory} from "../_i/factory/IUnhingedUserFactory.sol";

contract UnhingedUserFactory is UnhingedFactory, IUnhingedUserFactory {

    mapping(string => address) public userTakes; // username -> take contract
    mapping(address => string) public takeUsers; // take contract -> username
    string[] public allUsers;
    
    function onboardUser(
        string memory _username, 
        string memory _take, 
        uint8 _template, 
        address _user
    ) external returns (address takeAddress) {
        // Validate username
        if (bytes(_username).length == 0) revert InvalidUsername(_username);
        if (userTakes[_username] != address(0)) revert UserAlreadyExists(_username);
        
        // Deploy beacon proxy
        bytes memory initData = abi.encodeWithSelector(
            IUnhingedTake.initialize.selector,
            _username,
            _take,
            _template,
            admin,
            _user
        );
        
        BeaconProxy proxy = new BeaconProxy(address(beacon), initData);
        takeAddress = address(proxy);
        
        // Register user
        userTakes[_username] = takeAddress;
        takeUsers[takeAddress] = _username;
        allUsers.push(_username);
        
        emit UserOnboarded(_username, takeAddress, _user);
    }
    
    function getUserByUsername(string memory _username) external view returns (address) {
        return userTakes[_username];
    }
    
    function getUsernameByAddress(address _user) external view returns (string memory) {
        return takeUsers[_user];
    }
    
    function getAllUsers() external view returns (string[] memory) {
        return allUsers;
    }
    
    function getUserCount() external view returns (uint256) {
        return allUsers.length;
    }
}