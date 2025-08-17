// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import { UnhingedCommunicatorOnFlow } from "./lz/UnhingedCommunicatorOnFlow.sol";
import { UnhingedAdminCore } from "./core/UnhingedAdminCore.sol";


contract UnhingedAdminOnFlow is UnhingedAdminCore, UnhingedCommunicatorOnFlow {

    constructor(address _owner, address _admin) UnhingedAdminCore(_owner) {
        admin = _admin;
    }

}