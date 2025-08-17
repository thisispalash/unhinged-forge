// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22;

import {IUnhingedTake} from "../../_i/user/IUnhingedTake.sol";

/**
 * @title UnhingedTake
 * @author @isthispalash
 * @notice Functions that manage the spicy takes and related storage
 */
contract UnhingedTake is IUnhingedTake {

    uint256 public currentRevision;
    mapping(uint256 => Take) public takeHistory;

    uint256 public elo;
    uint256 public battleCount;
    mapping(uint256 battleId => string cdc) public battles; // cdc is the battle contract on Flow Cadence

    uint256 public challengeCount;
    mapping(uint256 challengeId => string cdc) public challenges;


    function initialize(string memory _username, string memory _take, uint8 _template, address _admin, address _owner) public initializer nonReentrant {
        __UnhingedUser_initializable(_owner, _admin, _username);

        currentRevision = 1;
        Take memory currentTake = Take({
            template: _template,
            revision: 1,
            text: _take
        });

        takeHistory[1] = currentTake;

        emit TakeUpdated(1, _template, _take);
    }

    /** Take Utility Functions */

    function updateTake(string memory _take) external override returns (uint256 revision) {
        return _updateTake(_take, takeHistory[currentRevision].template);
    }

    function updateTemplate(uint8 _template) external override returns (uint256 revision) {
        return _updateTake(takeHistory[currentRevision].text, _template);
    }

    function revise(uint8 _template, string memory _take) external override returns (uint256 revision) {
        return _updateTake(_take, _template);
    }

    function _updateTake(string memory _take, uint8 _template) internal override returns (uint256 revision) {

        currentRevision++;
        Take memory currentTake = Take({
            revision: currentRevision,
            template: _template,
            text: _take
        });

        takeHistory[currentRevision] = currentTake;

        emit TakeUpdated(currentRevision, _template, _take);

        return currentRevision;
    }

    /** Battle Functions */

    
}