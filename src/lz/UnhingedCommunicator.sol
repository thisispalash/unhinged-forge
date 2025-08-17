// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import { OAppUpgradeable, Origin, MessagingFee } from "@layerzerolabs/oapp-evm-upgradeable/contracts/oapp/OAppUpgradeable.sol";
import { OAppOptionsType3Upgradeable } from "@layerzerolabs/oapp-evm-upgradeable/contracts/oapp/libs/OAppOptionsType3Upgradeable.sol";
import { OptionsBuilder } from "@layerzerolabs/oapp-evm/contracts/oapp/libs/OptionsBuilder.sol";

struct LZConfig {
    uint32 eid;
    address endpoint;
    address executor;
}

/**
 * @title UnhingedCommunicator
 * @author @isthispalash
 * @notice Base contract to communicate between Base and FlowEVM
 */
abstract contract UnhingedCommunicator is 
    Initializable,
    OwnableUpgradeable,
    OAppUpgradeable,
    OAppOptionsType3Upgradeable
{

    error LZ_InvalidOrigin(uint32 expectedEid, uint32 actualEid);
    error LZ_InvalidExecutor(address expectedExecutor, address actualExecutor);


    LZConfig internal LZ_BASE = LZConfig({
        eid: 30184,
        endpoint: 0x1a44076050125825900e736c501f859c50fE728c,
        executor: 0x2CCA08ae69E0C44b18a57Ab2A87644234dAebaE4
    });

    LZConfig internal LZ_FLOW = LZConfig({
        eid: 30336,
        endpoint: 0xcb566e3B6934Fa77258d68ea18E931fa75e1aaAa,
        executor: 0xa20DB4Ffe74A31D17fc24BD32a7DD7555441058e
    });

    /// @notice Msg type for sending a string, for use in OAppOptionsType3 as an enforced option
    uint16 public constant SEND = 0;




    constructor(address _endpoint, address _owner) OAppUpgradeable(_endpoint) {
        initialize(_endpoint, _owner);
    }

    function initialize(address _endpoint, address _owner) public initializer {
        __Ownable_init(_owner);
        __OApp_init(_owner);
    }


    function _buildOptions(
        uint32 dstEid,
        uint16 msgType,
        address receiver,   // receiver on dst chain
        uint128 amountWei   // native drop amount on dst chain
    ) internal view returns (bytes memory options) {
        bytes memory extra = OptionsBuilder
            .newOptions()
            .addExecutorNativeDropOption(amountWei, bytes32(uint256(uint160(receiver))))
            .toBytes();

        options = combineOptions(dstEid, msgType, extra);
    }

    // address -> bytes32 helper
    function _addrToB32(address a) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(a)));
    }

    // Native drop (pay dst gas by airdropping native to receiver)
    function optionsNativeDrop(address receiver, uint128 amountWei) internal pure returns (bytes memory) {
        return OptionsBuilder.newOptions().addExecutorNativeDropOption(amountWei, _addrToB32(receiver));
    }

    // lzReceive gas/value option
    function optionsLzReceive(uint128 gasLimit, uint128 valueWei) internal pure returns (bytes memory) {
        return OptionsBuilder.newOptions().addExecutorLzReceiveOption(gasLimit, valueWei);
    }

    function _quote(LZConfig memory _dst, bytes memory _message) internal view returns (MessagingFee memory) {
        return _quote(_dst.eid, _message, optionsNativeDrop(_dst.executor, 0), false);
    }




    /** 
     * Different Message Types supported,
     * 
     * FLOW is `_lzReceive`, Base is `_lzSend` :: asc. (1, 2, 3, ...)
     * Base is `_lzReceive`, FLOW is `_lzSend` :: desc. (65535, 65534, ...)
     * 
     * @dev during deployment, the gas is profiled for these message types and 
     * `enforcedOptions` are set.
     */
    
    uint16 public constant REGISTER_USER_ON_FLOW = 1;
    uint16 public constant START_BATTLE_ON_FLOW = 2;
    uint16 public constant KICK_CHALLENGER = 3;
    uint16 public constant CALLOUT_NPC = 4;


    uint16 public constant DEFENDER_TIMEOUT = 65535;
    uint16 public constant DEFENDER_TAP_OUT = 65534;
    uint16 public constant CHALLENGER_TIMEOUT = 65533;
    uint16 public constant CHALLENGER_TAP_OUT = 65532;
    uint16 public constant AGREE_TO_DISAGREE = 65531;
    uint16 public constant NPC_CRASH_OUT = 65530;

    struct MessageStruct_REGISTER_USER_ON_FLOW {
        string username;
        address user;
    }

    struct MessageStruct_START_BATTLE_ON_FLOW {
        address defender;
        address challenger;
    }

    struct MessageStruct_KICK_CHALLENGER {
        address challenger; // the new challenger
    }

    struct MessageStruct_CALLOUT_NPC {
        address participant;
        address accuser;
    }

    struct MessageStruct_DEFENDER_TIMEOUT {
        address battle;
    }
    
}