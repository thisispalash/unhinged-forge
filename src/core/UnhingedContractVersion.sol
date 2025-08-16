// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

contract UnhingedContractVersion {
    function getContractVersion() external pure returns (string memory) {
        return "1.0.0";
    }
}