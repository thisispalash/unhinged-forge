// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import { OAppUpgradeable, Origin, MessagingFee } from "@layerzerolabs/oapp-evm-upgradeable/contracts/oapp/OAppUpgradeable.sol";
import { OAppOptionsType3Upgradeable } from "@layerzerolabs/oapp-evm-upgradeable/contracts/oapp/libs/OAppOptionsType3Upgradeable.sol";
import { OptionsBuilder } from "@layerzerolabs/oapp-evm/contracts/oapp/libs/OptionsBuilder.sol";

import { IUnhingedCommunicator, LZConfig } from "../_i/IUnhingedCommunicatorBase.sol";

/**
 * @title UnhingedCommunicator
 * @author @isthispalash
 * @notice Base contract to communicate between Base and FlowEVM
 */
abstract contract UnhingedCommunicator is 
    Initializable,
    OwnableUpgradeable,
    OAppUpgradeable,
    OAppOptionsType3Upgradeable,
    IUnhingedCommunicator
{

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

    uint16 public constant SEND = 0; // send an arbitrary message, fallback
    uint16 public constant START_BATTLE = 1; // new battle has started, send cadence address to Base
    
    /// @dev 7 battle resolutions are different message types for accurate gas profiling
    uint16 public constant AGREE_TO_DISAGREE = 2; // resolve battle, kind of draw
    uint16 public constant TAP_OUT_CHALLENGER = 3; // resolve battle, challengers lost (tap out)
    uint16 public constant TAP_OUT_DEFENDER = 4; // resolve battle, defender lost (tap out)
    uint16 public constant TIMEOUT_CHALLENGER = 5; // resolve battle, challengers lost (timed out)
    uint16 public constant TIMEOUT_DEFENDER = 6; // resolve battle, defender lost (timed out)
    uint16 public constant NPC_CHALLENGER = 7; // resolve battle, challengers lost (called npc)
    uint16 public constant NPC_DEFENDER = 8; // resolve battle, defender lost (called npc)

    LZConfig public LZ_SELF;

    constructor(address _endpoint, address _owner) OAppUpgradeable(_endpoint) {
        initialize(_endpoint, _owner);
    }

    function initialize(address _endpoint, address _owner) public initializer {
        __Ownable_init(_owner);
        __OApp_init(_owner);

        if (_endpoint == LZ_BASE.endpoint) {
            LZ_SELF = LZ_BASE;
        } else if (_endpoint == LZ_FLOW.endpoint) {
            LZ_SELF = LZ_FLOW;
        }
    }

    function _addrToB32(address a) internal pure returns (bytes32) {
        return bytes32(uint256(uint160(a)));
    }

    function _b32ToAddr(bytes32 a) internal pure returns (address) {
        return address(uint160(uint256(a)));
    }

    function handleFallback(bytes4 selector, bytes memory data) internal virtual;

    function handleStartBattle(address defender, address challenger, string memory cdc) internal virtual;

    function handleResolveBattle(uint16 msgType, bytes memory data) internal virtual;
}