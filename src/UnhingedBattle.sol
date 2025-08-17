// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22;

import {UnhingedBattleCore} from "./core/game/UnhingedBattleCore.sol";
import {UnhingedVault} from "./core/game/UnhingedVault.sol";
import {UnhingedPrediction} from "./core/game/UnhingedPrediction.sol";

contract UnhingedBattle is UnhingedBattleCore, UnhingedVault, UnhingedPrediction {

}