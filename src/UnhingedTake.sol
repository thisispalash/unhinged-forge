// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {IUnhingedTake} from "./_i/IUnhingedTake.sol";
import {UnhingedUser} from "./core/UnhingedUser.sol";

contract UnhingedTake is 
    IUnhingedTake,
    UnhingedUser
{

    Take public currentTake;
    uint256 public currentRevision;

    mapping(uint256 => Take) public takeHistory;

    function initialize(string memory _username, string memory _take, uint8 _template, address _admin, address _owner) public initializer nonReentrant {
        __UnhingedUser_initializable(_owner, _admin, _username);

        currentRevision = 1;
        currentTake = Take({
            template: _template,
            revision: 1,
            text: _take
        });

        takeHistory[1] = currentTake;

        emit TakeUpdated(1, _template, _take);
    }

    /** Take Utility Functions */

    function updateTake(string memory _take) external override returns (uint256 revision) {
        return _updateTake(_take, currentTake.template);
    }

    function updateTemplate(uint8 _template) external override returns (uint256 revision) {
        return _updateTake(currentTake.text, _template);
    }

    function revise(uint8 _template, string memory _take) external override returns (uint256 revision) {
        return _updateTake(_take, _template);
    }

    /** Battle Functions */

    

    function _updateTake(string memory _take, uint8 _template) internal override returns (uint256 revision) {

        currentRevision++;
        currentTake = Take({
            revision: currentRevision,
            template: _template,
            text: _take
        });

        takeHistory[currentRevision] = currentTake;

        emit TakeUpdated(currentRevision, _template, _take);

        return currentRevision;
    }
}