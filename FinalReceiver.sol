// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract FinalReceiver {
    event TrapExecuted(uint256 timestamp);
    
    function execute() external {
        emit TrapExecuted(block.timestamp);
    }
}
