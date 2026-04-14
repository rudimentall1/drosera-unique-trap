// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "drosera-contracts/interfaces/ITrap.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract TreasuryRapidDrainDetector is ITrap {
    address public immutable PROTECTED_CONTRACT;
    address public immutable TOKEN_ADDRESS;
    bool public immutable IS_ERC20;
    
    constructor(
        address _protectedContract,
        address _tokenAddress,
        bool _isERC20
    ) {
        PROTECTED_CONTRACT = _protectedContract;
        TOKEN_ADDRESS = _tokenAddress;
        IS_ERC20 = _isERC20;
    }
    
    function collect() external view override returns (bytes memory) {
        uint256 currentBalance;
        
        if (IS_ERC20) {
            currentBalance = IERC20(TOKEN_ADDRESS).balanceOf(PROTECTED_CONTRACT);
        } else {
            currentBalance = PROTECTED_CONTRACT.balance;
        }
        
        return abi.encode(currentBalance);
    }
    
    function shouldRespond(
        bytes[] calldata data
    ) external pure override returns (bool, bytes memory) {
        if (data.length == 0 || data[0].length == 0) {
            return (false, bytes(""));
        }
        
        if (data.length < 2 || data[1].length == 0) {
            return (false, bytes(""));
        }
        
        uint256 currentBalance = abi.decode(data[0], (uint256));
        uint256 previousBalance = abi.decode(data[1], (uint256));
        
        uint256 thresholdAmount = (previousBalance * 20) / 100;
        
        bool isRapidDrain = previousBalance > currentBalance && 
                            (previousBalance - currentBalance) >= thresholdAmount;
        
        if (isRapidDrain) {
            uint256 drained = previousBalance - currentBalance;
            uint256 percent = (drained * 100) / previousBalance;
            return (true, abi.encode(previousBalance, currentBalance, drained, percent));
        }
        
        return (false, bytes(""));
    }
    
    function getCurrentBalance() external view returns (uint256) {
        if (IS_ERC20) {
            return IERC20(TOKEN_ADDRESS).balanceOf(PROTECTED_CONTRACT);
        } else {
            return PROTECTED_CONTRACT.balance;
        }
    }
}
