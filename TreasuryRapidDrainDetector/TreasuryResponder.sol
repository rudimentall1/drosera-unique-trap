// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IProtocol {
    function pause() external;
}

contract TreasuryResponder {
    address public immutable protocol;
    
    event DrainDetected(
        address indexed treasury,
        uint256 previousBalance,
        uint256 currentBalance,
        uint256 drainedAmount,
        uint256 drainPercent,
        uint256 blockNumber
    );
    
    constructor(address _protocol) {
        protocol = _protocol;
    }
    
    function pause(
        address treasury,
        uint256 previousBalance,
        uint256 currentBalance
    ) external {
        uint256 drained = previousBalance - currentBalance;
        uint256 percent = (drained * 100) / previousBalance;
        
        emit DrainDetected(
            treasury,
            previousBalance,
            currentBalance,
            drained,
            percent,
            block.number
        );
        
        // Вызываем паузу на защищаемом протоколе
        IProtocol(protocol).pause();
    }
}
