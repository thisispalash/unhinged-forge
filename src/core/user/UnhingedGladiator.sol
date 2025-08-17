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

    function __UnhingedGladiator_initializable() public initializer {
        __Pausable_init();
    }

    function startBattle(
        string memory _cdc
    ) external returns (uint256 battleId) {
        battleCount++;
        battleRefs[battleCount] = _cdc;
        cdcToBattleId[_cdc] = battleCount;
        return battleCount;
    }

    function endBattle(uint256 _battleId, BattleOutcome _outcome) external {
        battleOutcomes[_battleId] = _outcome;
    }

    function getBattleOutcome(
        uint256 _battleId
    ) external view returns (BattleOutcome) {
        return battleOutcomes[_battleId];
    }

    function endBattle(string memory _cdc, BattleOutcome _outcome) external {
        uint256 battleId = cdcToBattleId[_cdc];
        battleOutcomes[battleId] = _outcome;
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
}
