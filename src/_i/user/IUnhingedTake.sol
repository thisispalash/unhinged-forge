// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

/**
 * @title IUnhingedTake
 * @author @isthispalash
 * @notice Functions that manage the spicy takes and related storage
 */
interface IUnhingedTake {

    struct Take {
        uint256 revision;
        uint8 template;
        string text;
    }

    /**
     * Error caused when the Supporter has insufficient USDC balance to support
     */
    error EmptySupport(address supporter, uint256 balance);

    /**
     * Error caused when the Supporter has not approved USDC for transfer
     */
    error FalseSupport(address supporter);

    /**
     * Emitted when there is a new mint of a take
     * 
     * @param supporter Address of the account minting a take
     * @param supportNumber Equivalent to token ID
     * @param revision Revision number of the take
     */
    event NewSupporter(address indexed supporter, uint256 indexed supportNumber, uint256 indexed revision);


    /**
     * Emitted when a take is updated
     * 
     * @param revision The revision number of the take
     * @param template The template of the take
     * @param text The text of the take
     */
    event TakeUpdated(uint256 indexed revision, uint8 indexed template, string text);

    /**
     * Updates the text of the take
     * 
     * @param _take The new text of the take
     */
    function updateTake(string memory _take) external returns (uint256 revision);

    /**
     * Updates the template of the take
     * 
     * @param _template The new template of the take
     */
    function updateTemplate(uint8 _template) external returns (uint256 revision);

    /**
     * Convenience function to update template and text of the take
     * 
     * @param _template The new template
     * @param _take The new text
     */
    function revise(uint8 _template, string memory _take) external returns (uint256 revision);

    /**
     * Gets the take at a particular revision
     * 
     * @param _revision The revision number of the take
     * @return The take at the revision
     */
    function getTake(uint256 _revision) external view returns (Take memory);

    /**
     * Gets the current revision number of the take
     * 
     * @return The current revision number of the take
     */
    function getCurrentRevision() external view returns (uint256);

    /**
     * Gets the number of supporters of the take
     * 
     * @return The number of supporters of the take
     */
    function getSupporterCount() external view returns (uint256);
}