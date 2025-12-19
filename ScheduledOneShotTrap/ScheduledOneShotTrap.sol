// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import "drosera-contracts/interfaces/ITrap.sol";

contract ScheduledOneShotTrap is ITrap {
    // Usecase: Этот трап предназначен для однократного автоматического срабатывания
    // (например, отправки транзакции) в течение определенного блока (SCHEDULED_BLOCK).
    // После срабатывания он никогда больше не активируется.
    // Это полезно для одноразовых задач по расписанию в рамках безопасного
    // и детерминированного фреймворка Drosera.
    
    uint256 public constant SCHEDULED_BLOCK = 1856179; // Текущий блок 1856079 + 100
    uint256 public constant COOLDOWN_BLOCKS = 0; // Уже правильный формат!

    // Функция collect ДОЛЖНА быть external view и возвращать bytes memory.
    function collect() external view override returns (bytes memory) {
        // Возвращаем текущий номер блока как детерминированные данные.
        // Это соответствует стандарту: данные для анализа в shouldRespond.
        return abi.encode(block.number);
    }

    // Функция shouldRespond ДОЛЖНА быть external pure, принимать массив байтов
    // и возвращать (bool, bytes memory). Ключевое слово `override` обязательно.
    function shouldRespond(
        bytes[] calldata data
    ) external pure override returns (bool, bytes memory) {
        
        // ===== ИСПРАВЛЕНИЕ 2: Защита от пустых данных =====
        // Некоторые планеры/операторы могут передавать пустые data.
        // Это предотвратит revert и вернет корректный false.
        if (data.length == 0 || data[0].length == 0) {
            // ===== ИСПРАВЛЕНИЕ 3: Возвращаем bytes(""), а не "" =====
            return (false, bytes(""));
        }

        // Предполагаем, что data[0] - это результат последнего вызова collect(),
        // закодированный как abi.encode(blockNumber).
        // Это безопасно, так как collect() всегда возвращает encoded uint256.
        uint256 newestSample = abi.decode(data[0], (uint256));
        
        // Для реализации "rising edge" (однократного срабатывания) нам нужен
        // не только текущий блок (newestSample), но и предыдущий.
        // Drosera передает исторические данные. При `block_sample_size = 2`
        // data[0] - самый новый, data[1] - предыдущий.
        if (data.length < 2) {
            // Если исторических данных недостаточно, не срабатываем.
            return (false, bytes(""));
        }
        uint256 previousSample = abi.decode(data[1], (uint256));
        
        // ===== ИСПРАВЛЕНИЕ 4: Логика "Rising Edge" (одноразовое срабатывание) =====
        // Трап сработает ТОЛЬКО ОДИН РАЗ, когда мы ПЕРЕСЕКЛИ запланированный блок:
        // Предыдущий блок был <= SCHEDULED_BLOCK, а текущий стал > SCHEDULED_BLOCK.
        bool triggerCondition = previousSample <= SCHEDULED_BLOCK && newestSample > SCHEDULED_BLOCK;
        
        if (triggerCondition) {
            // Если условие выполнено, возвращаем true и полезную нагрузку (payload).
            // Payload может быть декодирован Responder-контрактом, который ожидает uint256.
            // Например, он может использовать этот номер блока для своей логики.
            return (true, abi.encode(newestSample));
        } else {
            // Во всех остальных случаях (до, после или если уже сработал) - false.
            return (false, bytes(""));
        }
    }
    
    // Опционально: функция для проверки состояния трапа.
    // Может быть полезна для тестов и отладки.
    function getTrapInfo() external pure returns (
        uint256 scheduledBlock,
        uint256 cooldownBlocks,
        string memory usecase
    ) {
        usecase = "One-time scheduled execution at a specific future block. Safety: only triggers once on the block transition.";
        return (SCHEDULED_BLOCK, COOLDOWN_BLOCKS, usecase);
    }
}
