# Drosera Unique Traps

## TreasuryRapidDrainDetector

Реальный security-трап для защиты казначейства от резкого вывода средств.

**Use case:** Протокол хранит 1000 ETH в казначействе. Хакер получает доступ к приватному ключу и выводит 300 ETH за один блок. Трап срабатывает на порог >20% и вызывает `pause()`. Оставшиеся 700 ETH сохранены.

**Как работает:**
1. `collect()` — читает баланс казначейства каждый блок
2. `shouldRespond()` — сравнивает с предыдущим балансом
3. При падении >20% возвращает payload: `(previous, current, drained, percent)`
4. Responder декодирует payload, эмитит событие, вызывает `pause()`

**Безопасность:**
- `authorizedExecutors` — только доверенные адреса могут вызвать `pause()`
- `Ownable` — возможность добавлять/удалять исполнителей
- Обновляемый список executor-ов

**Deployment (Hoodi):**
- Trap: `0x133d815B79D8ED4f824c77aF0E739bF75f19B56D`
- Responder: `0x43689d3C0301592AC79C3635B2dEBF4835cF3f5a`

**Тесты:** 4/4 passed

**Конфиг:** `drosera-treasury.toml`

---

## ScheduledOneShotTrap

Демо-трап для отложенного одноразового срабатывания по блоку.

**Адрес (Hoodi):** `0x4FB582e1aEA38F8Ce109061A0DDf466AD0cf18Ec`
