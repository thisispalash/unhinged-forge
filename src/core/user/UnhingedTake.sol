// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {IUnhingedTake} from "../../_i/user/IUnhingedTake.sol";

/**
 * @title UnhingedTake
 * @author @isthispalash
 * @notice Functions that manage the spicy takes and related storage
 */
contract UnhingedTake is Initializable, ERC721Upgradeable, IUnhingedTake {
    
    IERC20 public constant USDC = IERC20(0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913); // USDC on Base
    uint256 public constant PRICE = 10000; // a penny for your thoughts

    uint256 public currentRevision;
    mapping(uint256 => Take) public takeHistory;

    uint256 public supporterCount;
    mapping(address _supporter => uint256 revisionNumber) public supporters;

    function __UnhingedTake_initializable(
        string memory _username,
        string memory _take,
        uint8 _template
    ) public initializer {
        __ERC721_init(_username, _makeSymbol(_username));

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

    function updateTake(
        string memory _take
    ) external returns (uint256 revision) {
        return _updateTake(_take, takeHistory[currentRevision].template);
    }

    function getTake(uint256 _revision) external view returns (Take memory) {
        return takeHistory[_revision];
    }

    function updateTemplate(
        uint8 _template
    ) external returns (uint256 revision) {
        return _updateTake(takeHistory[currentRevision].text, _template);
    }

    function revise(
        uint8 _template,
        string memory _take
    ) external returns (uint256 revision) {
        return _updateTake(_take, _template);
    }

    function _updateTake(
        string memory _take,
        uint8 _template
    ) internal returns (uint256 revision) {
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

    function getCurrentRevision() external view override returns (uint256) {
        return currentRevision;
    }

    /** ERC721 Functions */

    function getSupporterCount() external view override returns (uint256) {
        return supporterCount;
    }

    function _support(address _supporter) internal returns (uint256, uint256) {
        supporterCount++;
        _safeMint(_supporter, supporterCount);

        emit NewSupporter(_supporter, supporterCount, currentRevision);
        supporters[_supporter] = currentRevision;

        return (supporterCount, currentRevision);
    }

    function _makeSymbol(
        string memory _username
    ) internal pure returns (string memory) {
        return string(abi.encode(_username, ".unhinged"));
    }
}