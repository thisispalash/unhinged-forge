// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import { UnhingedCommunicator, Origin, MessagingFee } from "./UnhingedCommunicator.sol";

contract UnhingedCommunicatorOnFlow is UnhingedCommunicator {
    /// @dev gas for each message type to be set in deployment script via profiling
    mapping(uint16 msgType => uint256 gas) internal msgGas;

    constructor(
        address _owner
    ) UnhingedCommunicator(LZ_FLOW.endpoint, _owner) {}

    function startBattle(
        address defender,
        address challenger,
        string memory cdc
    ) external {
        bytes memory msgData = abi.encode(defender, challenger, cdc);
        messageHandler(START_BATTLE, msgData);
    }

    function messageHandler(uint16 msgType, bytes memory msgData) public {
        if (msgType == 0) {
            (bytes4 selector, bytes memory data) = abi.decode(
                msgData,
                (bytes4, bytes)
            );
            handleFallback(selector, data);
        } else if (msgType == 1) {
            (address defender, address challenger, string memory cdc) = abi
                .decode(msgData, (address, address, string));
            handleStartBattle(defender, challenger, cdc);
        } else if (msgType >= 2 && msgType <= 8) {
            handleResolveBattle(msgType, msgData);
        }

        _lzSend(
            LZ_BASE.eid,
            abi.encode(msgType, msgData),
            enforcedOptions(LZ_BASE.eid, msgType), /// @dev we don't need to add any extra options here
            MessagingFee(msgGas[msgType], 0),
            address(this)
        );
    }

    function handleFallback(
        bytes4 selector,
        bytes memory data
    ) internal override {
        revert("UnhingedCommunicatorOnFlow: fallback not implemented");
    }

    function handleStartBattle(
        address defender,
        address challenger,
        string memory cdc
    ) internal override {
        revert("UnhingedCommunicatorOnFlow: start battle not implemented");
    }

    function handleResolveBattle(
        uint16 msgType,
        bytes memory data
    ) internal override {
        revert("UnhingedCommunicatorOnFlow: resolve battle not implemented");
    }

    function _lzReceive(
        Origin calldata _origin,
        bytes32 _guid,
        bytes calldata _message,
        address _executor,
        bytes calldata _extraData
    ) internal virtual override {
        revert("UnhingedCommunicatorOnFlow: Flow does not receive messages");
    }
}