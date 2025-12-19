// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20; // 🔥 Изменили на 0.8.20

import "drosera-contracts/interfaces/ITrap.sol"; // Проверим путь

contract ScheduledOneShotTrap is ITrap {
    // Usecase: One-time scheduled execution at specific future block
    uint256 public constant SCHEDULED_BLOCK = 1856179;
    // 🔥 COOLDOWN_BLOCKS удаляем или комментируем - не используется
    // uint256 public constant COOLDOWN_BLOCKS = 0;

    function collect() external view override returns (bytes memory) {
        return abi.encode(block.number);
    }

    function shouldRespond(
        bytes[] calldata data
    ) external pure override returns (bool, bytes memory) {
        // 🔥 Защита от пустых данных (уже было)
        if (data.length == 0 || data[0].length == 0) {
            return (false, bytes(""));
        }
        
        // 🔥 НОВОЕ: Защита от пустого data[1]
        if (data.length < 2 || data[1].length == 0) {
            return (false, bytes(""));
        }

        uint256 newestSample = abi.decode(data[0], (uint256));
        uint256 previousSample = abi.decode(data[1], (uint256));
        
        // Rising edge логика (правильно)
        bool triggerCondition = previousSample <= SCHEDULED_BLOCK && newestSample > SCHEDULED_BLOCK;
        
        if (triggerCondition) {
            // 🔥 ВАРИАНТ А: Возвращаем payload с номером блока
            return (true, abi.encode(newestSample));
            // 🔥 ВАРИАНТ Б: Если responder не принимает аргументы:
            // return (true, bytes(""));
        } else {
            return (false, bytes(""));
        }
    }
    
    // 🔥 УДАЛЯЕМ getTrapInfo или оставляем для удобства
    function getTrapInfo() external pure returns (
        uint256 scheduledBlock,
        string memory usecase
    ) {
        usecase = "One-time scheduled execution at a specific future block. Safety: only triggers once on the block transition.";
        return (SCHEDULED_BLOCK, usecase);
    }
}
