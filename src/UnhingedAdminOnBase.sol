// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;


import { UnhingedAdminCore } from "./core/UnhingedAdminCore.sol";
import { UnhingedCommunicatorOnBase } from "./lz/UnhingedCommunicatorOnBase.sol";

contract UnhingedAdminOnBase is UnhingedAdminCore, UnhingedCommunicatorOnBase {

    constructor(address _owner, address _admin) UnhingedAdminCore(_owner) {
        admin = _admin;
    }

}