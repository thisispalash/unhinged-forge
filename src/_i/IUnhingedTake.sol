// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

interface IUnhingedTake {

    struct Take {
        uint256 revision;
        uint8 template;
        string text;
    }

    /**
     * Emitted when a take is updated
     * 
     * @param revision The revision number of the take
     * @param template The template of the take
     * @param text The text of the take
     */
    event TakeUpdated(uint256 indexed revision, uint8 indexed template, string text);

    /**
     * Initializes the take
     * 
     * @param _username The username from twitter
     * @param _take The text of the take
     * @param _template The template of the take
     * @param _owner The owner of the take
     * @param _admin Admin contract address
     */
    function initialize(string memory _username, string memory _take, uint8 _template, address _owner, address _admin) external;

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

    function startBattle() external returns (address battle);
}