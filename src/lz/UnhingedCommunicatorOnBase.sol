// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import { UnhingedCommunicator, Origin, MessagingFee } from "./UnhingedCommunicator.sol";

contract UnhingedCommunicatorOnBase is UnhingedCommunicator {
    
    address public FLOW_ADMIN;

    constructor(
        address _owner,
        address _flowAdmin
    ) UnhingedCommunicator(LZ_FLOW.endpoint, _owner) {
        FLOW_ADMIN = _flowAdmin;
    }

    function updateFlowAdmin(address _flowAdmin) external onlyOwner {
        FLOW_ADMIN = _flowAdmin;
    }

    function _lzReceive(
        Origin calldata _origin,
        bytes32 _guid,
        bytes calldata _message,
        address _executor,
        bytes calldata _extraData
    ) internal override {
        require(
            _origin.srcEid == LZ_FLOW.eid,
            LZ_InvalidOrigin(LZ_FLOW.eid, _origin.srcEid)
        );
        require(
            _executor == LZ_FLOW.executor,
            LZ_InvalidExecutor(LZ_FLOW.executor, _executor)
        );
        require(
            _origin.sender == _addrToB32(FLOW_ADMIN),
            LZ_UnknownSender(FLOW_ADMIN, _b32ToAddr(_origin.sender))
        );

        (uint16 _messageType, bytes memory _remainder) = abi.decode(
            _message,
            (uint16, bytes)
        );

        if (_messageType == 0) {
            (bytes4 selector, bytes memory data) = abi.decode(
                _remainder,
                (bytes4, bytes)
            );
            handleFallback(selector, data);
        } else if (_messageType == 1) {
            (address defender, address challenger, string memory cdc) = abi
                .decode(_remainder, (address, address, string));
            handleStartBattle(defender, challenger, cdc);
        } else if (_messageType >= 2 && _messageType <= 8) {
            handleResolveBattle(_messageType, _remainder);
        } else {
            revert LZ_InvalidMessageType(_messageType);
        }
    }

    function handleFallback(
        bytes4 selector,
        bytes memory data
    ) internal override {
        revert("UnhingedCommunicatorOnBase: fallback not implemented");
    }

    function handleStartBattle(
        address defender,
        address challenger,
        string memory cdc
    ) internal override {
        revert("UnhingedCommunicatorOnBase: start battle not implemented");
    }

    function handleResolveBattle(
        uint16 msgType,
        bytes memory data
    ) internal override {
        revert("UnhingedCommunicatorOnBase: resolve battle not implemented");
    }

    function messageHandler(
        uint16 msgType,
        bytes memory data
    ) external override {}
}