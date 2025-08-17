// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22;


struct LZConfig {
    uint32 eid;
    address endpoint;
    address executor;
}

interface IUnhingedCommunicator  {

    error LZ_InvalidOrigin(uint32 expectedEid, uint32 actualEid);
    error LZ_InvalidExecutor(address expectedExecutor, address actualExecutor);
    error LZ_UnknownSender(address expectedSender, address actualSender);
    error LZ_InvalidMessageType(uint16 receivedType);

    /** Message Structs for the different message types */

    struct MESSAGE_FALLBACK {
        uint16 msgType;
        bytes4 selector;
        bytes data;
    }

    struct MESSAGE_START_BATTLE {
        uint16 msgType;
        address defender;
        address challenger;
        string cdc; // battle contract
    }

    struct MESSAGE_RESOLVE_BATTLE {
        uint16 msgType;
        mapping(address participant => uint256 elo) scores;
        string cdc; // battle contract
    }

    function messageHandler(uint16 msgType, bytes memory data) external;
}