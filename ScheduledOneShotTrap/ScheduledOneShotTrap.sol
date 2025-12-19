// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "drosera-contracts/interfaces/ITrap.sol";

contract ScheduledOneShotTrap is ITrap {
    uint256 public constant SCHEDULED_BLOCK = 1856179;

    function collect() external view override returns (bytes memory) {
        return abi.encode(block.number);
    }

    function shouldRespond(
        bytes[] calldata data
    ) external pure override returns (bool, bytes memory) {
        // 1. Проверяем data[0]
        if (data.length == 0 || data[0].length == 0) {
            return (false, bytes(""));
        }
        
        // 2. Проверяем data[1] ПЕРЕД decode!
        if (data.length < 2 || data[1].length == 0) {
            return (false, bytes(""));
        }

        // 3. Только теперь декодируем
        uint256 newestSample = abi.decode(data[0], (uint256));
        uint256 previousSample = abi.decode(data[1], (uint256));
        
        // 4. Rising edge логика
        bool triggerCondition = previousSample <= SCHEDULED_BLOCK && newestSample > SCHEDULED_BLOCK;
        
        if (triggerCondition) {
            return (true, abi.encode(newestSample));
        } else {
            return (false, bytes(""));
        }
    }
}
