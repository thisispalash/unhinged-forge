// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22;

/**
 * @title IUnhingedSpectator
 * @author @isthispalash
 * @notice Functions that manage the spectator side of things for all battles
 */
interface IUnhingedSpectator {
    
    enum ChallengeOutcome {
        IS_ACTIVE,
        AGREE_TO_DISAGREE,
        TIMED_OUT,
        TAPPED_OUT,
        REPLACED
    }

    function startChallenge(string memory _cdc) external;

    function replaceChallenger(address _challenger, string memory _cdc) external;
    function replacedByChallenger(address _challenger, string memory _cdc) external;

    function endChallenge(uint256 _challengeId, ChallengeOutcome _outcome) external;
    function endChallenge(string memory _cdc, ChallengeOutcome _outcome) external;

    function getChallengeId(string memory _cdc) external view returns (uint256);
    function getChallengeRef(uint256 _challengeId) external view returns (string memory);
    function getReplacer(uint256 _challengeId) external view returns (address);
    function getReplacee(uint256 _challengeId) external view returns (address);
    
    function getChallengeOutcome(uint256 _challengeId) external view returns (ChallengeOutcome);
    function getChallengeOutcome(string memory _cdc) external view returns (ChallengeOutcome);
}