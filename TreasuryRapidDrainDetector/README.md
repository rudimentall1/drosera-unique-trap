# TreasuryRapidDrainDetector

**Real security trap for Drosera Network**

Detects rapid drainage of funds from treasury or liquidity pool.

## Deployment

| Field | Value |
|-------|-------|
| Network | Hoodi |
| Chain ID | 560048 |
| Address | `0x133d815B79D8ED4f824c77aF0E739bF75f19B56D` |
| Transaction | `0x5347304acab4db714735cd4672b9a4e96e26d65a93352d6a15c7320ce87ccda4` |

## How it works

1. Collects balance every N blocks
2. Compares with previous balance
3. Triggers if drop > 20% in one block

## Test Results

3 tests passed (no drain / rapid drain / empty data)

## Use Cases

- Treasury drain protection
- Liquidity pool monitoring
- Bridge hack prevention

## License MIT
