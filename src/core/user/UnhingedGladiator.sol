// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";

import {IUnhingedGladiator} from "../../_i/user/IUnhingedGladiator.sol";

/**
 * @title UnhingedGladiator
 * @author @isthispalash
 * @notice Functions that manage the defender side of things for all battles
 */
contract UnhingedGladiator is
    Initializable,
    PausableUpgradeable,
    IUnhingedGladiator
{
    uint256 public battleCount;
    mapping(uint256 battleId => string cdc) internal battleRefs;
    mapping(string cdc => uint256 battleId) internal cdcToBattleId;
    mapping(uint256 battleId => BattleOutcome outcome) internal battleOutcomes;
    bool internal mustUpdateTake;

    modifier takeIsUpdated() {
        if (mustUpdateTake) {
            revert MustUpdateTake();
        }
        _;
    }

    function __UnhingedGladiator_initializable() public initializer {
        __Pausable_init();
    }

    function isPaused() external view returns (bool) {
        return paused();
    }

    function startBattle(
        string memory _cdc
    ) external whenNotPaused takeIsUpdated returns (uint256 battleId) {
        battleCount++;
        battleRefs[battleCount] = _cdc;
        cdcToBattleId[_cdc] = battleCount;
        return battleCount;
    }

    function endBattle(uint256 _battleId, BattleOutcome _outcome) external {
        _checkPunish(_outcome);
        battleOutcomes[_battleId] = _outcome;
    }

    function endBattle(string memory _cdc, BattleOutcome _outcome) external {
        _checkPunish(_outcome);
        uint256 battleId = cdcToBattleId[_cdc];
        battleOutcomes[battleId] = _outcome;
    }

    function getBattleOutcome(
        uint256 _battleId
    ) external view returns (BattleOutcome) {
        return battleOutcomes[_battleId];
    }

    function getBattleOutcome(
        string memory _cdc
    ) external view returns (BattleOutcome) {
        uint256 battleId = cdcToBattleId[_cdc];
        return battleOutcomes[battleId];
    }

    function getBattleRef(
        uint256 _battleId
    ) external view returns (string memory) {
        return battleRefs[_battleId];
    }

    function getBattleId(string memory _cdc) external view returns (uint256) {
        return cdcToBattleId[_cdc];
    }

    function _checkPunish(BattleOutcome _outcome) internal {
        if (_outcome == BattleOutcome.TIMEOUT_DEFENDER) {
            _pause();
        }
    }

    /**
     * @notice Defenders are encouraged to tap out rather than let their clock run out
     * @notice Defenders must update their take if they tap out
     * @param _outcome Outcome of the battle
     */
    function _consequences(BattleOutcome _outcome) internal {
        if (_outcome == BattleOutcome.TIMEOUT_DEFENDER) {
            _pause();
            _endAllBattles();
        } else if (_outcome == BattleOutcome.TAP_OUT_DEFENDER) {
            mustUpdateTake = true;
        }
    }

    /**
     * @notice Unimplemented
     */
    function _endAllBattles() internal {}

    /**
     * @notice Users are revived when someone supports their take
     */
    function _revive() internal whenPaused {
        _unpause();
    }
}