// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {ERC721Upgradeable} from "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import {PausableUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/PausableUpgradeable.sol";
import {ReentrancyGuardUpgradeable} from "@openzeppelin/contracts-upgradeable/utils/ReentrancyGuardUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import {UnhingedContractVersion} from "../UnhingedContractVersion.sol";
import {IUnhingedUser} from "../../_i/user/IUnhingedUser.sol";

/**
 * @title UnhingedUserCore
 * @author @isthispalash
 * @notice ERC721 functions for UnhingedUser + Pausable
 */
abstract contract UnhingedUserCore is
    Initializable,
    OwnableUpgradeable,
    ERC721Upgradeable,
    PausableUpgradeable,
    ReentrancyGuardUpgradeable,
    UnhingedContractVersion,
    IUnhingedUser
{

    IERC20 public constant USDC = IERC20(0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913); // USDC on Base
    uint256 public constant PRICE = 100000; // 0.1 USDC
    address public admin;

    uint256 supporterCount;
    uint256 revisionNumber;
    mapping(address _supporter => uint256 revisionNumber) supporters;

    modifier onlyAdmin() {
        require(msg.sender == admin, InvalidCaller(admin, msg.sender));
        _;
    }

    function __UnhingedUser_initializable(address _owner, address _admin, string memory _username) public initializer nonReentrant {
        __Ownable_init(_owner);
        __ERC721_init(_username, _makeSymbol(_username));
        __Pausable_init();
        __ReentrancyGuard_init();

        admin = _admin;
    }

    function support(address _supporter) public payable nonReentrant returns(uint256, uint256) {
        
        // Perform checks
        require(
            USDC.balanceOf(_supporter) >= PRICE, 
            EmptySupport(_supporter, USDC.balanceOf(_supporter))
        );
        require(
            USDC.allowance(_supporter, address(this)) >= PRICE,
            FalseSupport(_supporter)
        );


        // Transfer USDC
        USDC.transferFrom(_supporter, address(this), PRICE);
        USDC.transferFrom(address(this), admin, PRICE); // 0.5 USDC goes to admin


        // Mint new token / register support, and update
        supporterCount++;
        _safeMint(_supporter, supporterCount);

        emit NewSupporter(_supporter, supporterCount, revisionNumber);
        supporters[_supporter] = revisionNumber;

        return (supporterCount, revisionNumber);

    }

    function pause() public onlyAdmin {
        _pause();
    }

    function unpause() public onlyAdmin {
        _unpause();
    }

    function _updateTake(string memory _take, uint8 _template) internal virtual returns (uint256 revision);

    function _makeSymbol(string memory _username) internal pure returns (string memory) {
        return string(abi.encode(_username, ".unhinged"));
    }

}