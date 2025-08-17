// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.22;

import {UnhingedUserCore} from "./core/user/UnhingedUserCore.sol";
import {UnhingedTake} from "./core/user/UnhingedTake.sol";
import {UnhingedGladiator} from "./core/user/UnhingedGladiator.sol";
import {UnhingedSpectator} from "./core/user/UnhingedSpectator.sol";

contract UnhingedUser is
    UnhingedUserCore,
    UnhingedGladiator,
    UnhingedSpectator
{

    function initialize(address _admin, address _owner, string memory _username, string memory _take, uint8 _template) external {
        __UnhingedUserCore_initializable(_owner, _admin);
        __UnhingedTake_initializable(_username, _take, _template);
        __UnhingedSpectator_initializable();
        __UnhingedGladiator_initializable();
    }

    function _updateTake(string memory _take, uint8 _template) internal override returns (uint256 revision) {
        mustUpdateTake = false;
        return super._updateTake(_take, _template);
    }

    function support(address _supporter) public payable nonReentrant override returns (uint256, uint256) {
        if (isPaused()) {
            _revive();
        }
        return super.support(_supporter);
    }

}