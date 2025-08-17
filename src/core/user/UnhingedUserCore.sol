// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";

import {IUnhingedUser} from "../../_i/user/IUnhingedUser.sol";
import {UnhingedContractVersion} from "../UnhingedContractVersion.sol";
import {UnhingedTake} from "./UnhingedTake.sol";

/**
 * @title UnhingedUserCore
 * @author @isthispalash
 * @notice ERC721 functions for UnhingedUser + Pausable
 */
abstract contract UnhingedUserCore is
    Initializable,
    OwnableUpgradeable,
    ReentrancyGuardUpgradeable,
    UnhingedContractVersion,
    IUnhingedUser,
    UnhingedTake
{
    address public admin;
    uint256 public elo;

    modifier onlyAdmin() {
        require(msg.sender == admin, InvalidCaller(admin, msg.sender));
        _;
    }

    function __UnhingedUserCore_initializable(address _owner, address _admin) public initializer nonReentrant {
        __Ownable_init(_owner);
        __ReentrancyGuard_init();

        admin = _admin;
        elo = 120000; // 2 decimals
    }

    function support(address _supporter) public virtual payable returns(uint256, uint256) {
        
        // Perform checks
        require(
            USDC.balanceOf(_supporter) >= 2*PRICE, 
            EmptySupport(_supporter, USDC.balanceOf(_supporter))
        );
        require(
            USDC.allowance(_supporter, address(this)) >= 2*PRICE,
            FalseSupport(_supporter)
        );

        // Transfer USDC
        USDC.transferFrom(_supporter, address(this), PRICE);
        USDC.transferFrom(_supporter, admin, PRICE);

        return _support(_supporter);
    }
}