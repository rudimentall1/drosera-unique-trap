// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface ITrap {
    function collect() external view returns (bytes memory);
    function shouldRespond(bytes[] calldata data) external pure returns (bool, bytes memory);
}

contract SimpleTestTrap is ITrap {
    // Всегда возвращаем true после определенного блока
    uint256 public constant TRIGGER_BLOCK = 1789600; // Блок после вашей транзакции
    
    function collect() external view override returns (bytes memory) {
        return abi.encode(block.number);
    }

    function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
        if (data.length == 0) return (false, "");
        
        uint256 blockNum = abi.decode(data[0], (uint256));
        
        // Срабатываем если блок > TRIGGER_BLOCK
        if (blockNum > TRIGGER_BLOCK) {
            return (true, abi.encode(blockNum));
        }
        
        return (false, "");
    }
}
