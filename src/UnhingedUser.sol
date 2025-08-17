// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22;

import {UnhingedUserCore} from "./core/user/UnhingedUserCore.sol";
import {UnhingedTake} from "./core/user/UnhingedTake.sol";
import {UnhingedGladiator} from "./core/user/UnhingedGladiator.sol";
import {UnhingedSpectator} from "./core/user/UnhingedSpectator.sol";

contract UnhingedUser is
    UnhingedUserCore,
    UnhingedTake,
    UnhingedGladiator,
    UnhingedSpectator
{}