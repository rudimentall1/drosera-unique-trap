// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IProtocol {
    function pause() external;
}

contract TreasuryResponder {
    address public immutable protocol;
    address public immutable droseraExecutor;
    
    event DrainDetected(
        address indexed treasury,
        uint256 previousBalance,
        uint256 currentBalance,
        uint256 drainedAmount,
        uint256 drainPercent,
        uint256 blockNumber
    );
    
    constructor(address _protocol, address _droseraExecutor) {
        protocol = _protocol;
        droseraExecutor = _droseraExecutor;
    }
    
    function pause(bytes calldata data) external {
        require(msg.sender == droseraExecutor, "unauthorized");
        
        (uint256 previousBalance, uint256 currentBalance) = abi.decode(data, (uint256, uint256));
        
        uint256 drained = previousBalance - currentBalance;
        uint256 percent = (drained * 100) / previousBalance;
        
        emit DrainDetected(
            protocol,
            previousBalance,
            currentBalance,
            drained,
            percent,
            block.number
        );
        
        IProtocol(protocol).pause();
    }
}
