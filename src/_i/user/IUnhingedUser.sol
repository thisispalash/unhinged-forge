// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

/**
 * @title IUnhingedUser
 * @author @isthispalash
 * @notice Functions that manage the user operations, to be extended to smart account
 */
interface IUnhingedUser {

    /**
     * Error caused when the Supporter has insufficient USDC balance to support
     */
    error EmptySupport(address supporter, uint256 balance);

    /**
     * Error caused when the Supporter has not approved USDC for transfer
     */
    error FalseSupport(address supporter);

    /**
     * Error caused when a function expects a certain caller, but the actual caller is different
     */
    error InvalidCaller(address expected, address actual);


    /**
     * Emitted when there is a new mint of a take
     * 
     * @param supporter Address of the account minting a take
     * @param supportNumber Equivalent to token ID
     * @param revision Revision number of the take
     */
    event NewSupporter(address indexed supporter, uint256 indexed supportNumber, uint256 indexed revision);

    /**
     * 
     * @param _supporter Address of the account supporting a particular take
     * @return supportNumber Equivalent to token ID for regular ERC-721
     * @return revisionNumber 
     */
    function support(address _supporter) external payable returns(uint256 supportNumber, uint256 revisionNumber);
}