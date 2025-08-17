// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22;

/**
 * @title IUnhingedUserFactory
 * @author @isthispalash
 * @notice Functions that manage the creation of users
 */
interface IUnhingedUserFactory {

    event UserOnboarded(string indexed username, address indexed userAddress, address indexed user);
    
    error UserAlreadyExists(string username);
    error InvalidUsername(string username);
    
}