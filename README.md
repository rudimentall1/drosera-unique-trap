# Drosera Unique Traps

## TreasuryRapidDrainDetector

Ловит резкий вывод средств из казначейства или пула ликвидности.

Адрес (Hoodi): `0x133d815B79D8ED4f824c77aF0E739bF75f19B56D`

Как работает:
- Собирает баланс
- Сравнивает с предыдущим значением
- Если баланс упал больше чем на 20% за блок — срабатывает

Тесты: 3/3 прошли

Код: [TreasuryRapidDrainDetector/](TreasuryRapidDrainDetector/)

---

## ScheduledOneShotTrap

Демо-трап для отложенного одноразового срабатывания по блоку.

Адрес (Hoodi): `0x4FB582e1aEA38F8Ce109061A0DDf466AD0cf18Ec`

Код: [ScheduledOneShotTrap/](ScheduledOneShotTrap/)
