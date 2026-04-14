// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

interface IProtocol {
    function pause() external;
}

contract TreasuryResponder is Ownable {
    address public protocol;
    mapping(address => bool) public authorizedExecutors;
    
    event DrainDetected(
        address indexed treasury,
        uint256 previousBalance,
        uint256 currentBalance,
        uint256 drainedAmount,
        uint256 drainPercent,
        uint256 blockNumber
    );
    
    event ExecutorAdded(address indexed executor);
    event ExecutorRemoved(address indexed executor);
    event ProtocolUpdated(address indexed oldProtocol, address indexed newProtocol);
    
    constructor(address _protocol, address _initialExecutor) Ownable(msg.sender) {
        protocol = _protocol;
        authorizedExecutors[_initialExecutor] = true;
        emit ExecutorAdded(_initialExecutor);
    }
    
    modifier onlyAuthorized() {
        require(authorizedExecutors[msg.sender], "unauthorized");
        _;
    }
    
    function addExecutor(address executor) external onlyOwner {
        authorizedExecutors[executor] = true;
        emit ExecutorAdded(executor);
    }
    
    function removeExecutor(address executor) external onlyOwner {
        require(executor != msg.sender, "cannot remove self");
        authorizedExecutors[executor] = false;
        emit ExecutorRemoved(executor);
    }
    
    function updateProtocol(address newProtocol) external onlyOwner {
        address old = protocol;
        protocol = newProtocol;
        emit ProtocolUpdated(old, newProtocol);
    }
    
    function pause(bytes calldata data) external onlyAuthorized {
        (uint256 previousBalance, uint256 currentBalance, uint256 drained, uint256 percent) = 
            abi.decode(data, (uint256, uint256, uint256, uint256));
        
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
