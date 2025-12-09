# Drosera Unique Trap - rvvd

**Discord:** rvvd  
**Trap Address:** 0x069BBc7c66684A4A1e68f98FB004BE100E50cF0D  
**Response Contract:** 0xf32F6dA927128afa8e2E6D9132D5521659e3DE4c  
**Chain:** Hoodi (560048)  

## Описание
**SimpleTestTrap** - уникальный trap, который срабатывает когда `block.number > 1789600`.

## Код
- `SimpleTestTrap.sol` - основной trap контракт
- `FinalReceiver.sol` - response контракт (функция `execute()`)

## Доказательства работы
1. **Логи с ShouldRespond='true':**
   - Блок 1789723
   - Блок 1789876
   
2. **Транзакции:**
   - Обновление конфигурации: https://hoodi.etherscan.io/tx/[последняя-tx-hash]
   - Блок: 1789928
   
3. **Дашборд:**
   - https://app.drosera.io/trap?trapId=0x069bbc7c66684a4a1e68f98fb004be100e50cf0d

## Скриншоты
- [Логи с ShouldRespond='true']
- [Дашборд с темно-зелеными блоками]
