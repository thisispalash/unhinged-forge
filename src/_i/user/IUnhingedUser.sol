// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

/**
 * @title IUnhingedUser
 * @author @isthispalash
 * @notice Functions that manage the user operations, to be extended to smart account
 */
interface IUnhingedUser {


    /**
     * Error caused when a function expects a certain caller, but the actual caller is different
     */
    error InvalidCaller(address expected, address actual);

    /**
     * Initializes the user
     * 
     * @param _admin The admin of the user
     * @param _owner The owner of the user
     * @param _username The username of the user
     * @param _take The take of the user
     * @param _template The template of the user
     */
    function initialize(address _admin, address _owner, string memory _username, string memory _take, uint8 _template) external;

    /**
     * 
     * @param _supporter Address of the account supporting a particular take
     * @return supportNumber Equivalent to token ID for regular ERC-721
     * @return revisionNumber 
     */
    function support(address _supporter) external payable returns(uint256 supportNumber, uint256 revisionNumber);
}