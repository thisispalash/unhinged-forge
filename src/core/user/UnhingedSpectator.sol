// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import {IUnhingedSpectator} from "../../_i/user/IUnhingedSpectator.sol";

/**
 * @title UnhingedSpectator
 * @author @isthispalash
 * @notice Functions that manage the spectator side of things for all battles
 */
contract UnhingedSpectator is Initializable, IUnhingedSpectator {

    uint256 public challengeCount;
    mapping(uint256 challengeId => string cdc) internal challengeRefs;
    mapping(string cdc => uint256 challengeId) internal cdcToChallengeId;
    mapping(uint256 challengeId => address challenger) internal replaced;
    mapping(uint256 challengeId => address challenger) internal replacedBy;
    mapping(uint256 challengeId => ChallengeOutcome outcome) internal challengeOutcomes;

    function __UnhingedSpectator_initializable() public initializer {}

    function startChallenge(string memory _cdc) external {
        challengeCount++;
        challengeRefs[challengeCount] = _cdc;
        cdcToChallengeId[_cdc] = challengeCount;
    }

    function replaceChallenger(
        address _challenger,
        string memory _cdc
    ) external {
        challengeCount++;
        challengeRefs[challengeCount] = _cdc;
        replaced[challengeCount] = _challenger;
    }

    function replacedByChallenger(
        address _challenger,
        string memory _cdc
    ) external {
        uint256 challengeId = cdcToChallengeId[_cdc];
        replacedBy[challengeId] = _challenger;
        challengeOutcomes[challengeId] = ChallengeOutcome.REPLACED;
    }

    function endChallenge(
        uint256 _challengeId,
        ChallengeOutcome _outcome
    ) external {
        challengeOutcomes[_challengeId] = _outcome;
    }

    function endChallenge(
        string memory _cdc,
        ChallengeOutcome _outcome
    ) external {
        uint256 challengeId = cdcToChallengeId[_cdc];
        challengeOutcomes[challengeId] = _outcome;
    }

    function getChallengeId(
        string memory _cdc
    ) external view returns (uint256) {
        return cdcToChallengeId[_cdc];
    }

    function getChallengeRef(
        uint256 _challengeId
    ) external view returns (string memory) {
        return challengeRefs[_challengeId];
    }

    function getReplacer(uint256 _challengeId) external view returns (address) {
        return replacedBy[_challengeId];
    }

    function getReplacee(uint256 _challengeId) external view returns (address) {
        return replaced[_challengeId];
    }

    function getChallengeOutcome(
        uint256 _challengeId
    ) external view returns (ChallengeOutcome) {
        return challengeOutcomes[_challengeId];
    }

    function getChallengeOutcome(
        string memory _cdc
    ) external view returns (ChallengeOutcome) {
        uint256 challengeId = cdcToChallengeId[_cdc];
        return challengeOutcomes[challengeId];
    }

}