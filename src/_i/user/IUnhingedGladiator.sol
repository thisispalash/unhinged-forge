// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22;

/**
 * @title IUnhingedGladiator
 * @author @isthispalash
 * @notice Functions that manage the defender side of things for all battles
 */
interface IUnhingedGladiator {

    error MustUpdateTake();

    enum BattleOutcome {
        IS_ACTIVE,
        AGREE_TO_DISAGREE,
        TIMEOUT_DEFENDER,
        TIMEOUT_CHALLENGER,
        TAP_OUT_DEFENDER,
        TAP_OUT_CHALLENGER
    }

    function isPaused() external view returns (bool);

    function startBattle(string memory _cdc) external returns (uint256 battleId);
    function endBattle(uint256 _battleId, BattleOutcome _outcome) external;
    function endBattle(string memory _cdc, BattleOutcome _outcome) external;

    function getBattleId(string memory _cdc) external view returns (uint256);
    function getBattleRef(uint256 _battleId) external view returns (string memory);
    function getBattleOutcome(uint256 _battleId) external view returns (BattleOutcome);
    function getBattleOutcome(string memory _cdc) external view returns (BattleOutcome);

}