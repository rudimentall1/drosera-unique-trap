# TreasuryRapidDrainDetector

Designed for treasury drain detection in DeFi protocols.

## Architecture

```text
+-----------------+     +-----------------+     +-----------------+
| Every block     | --> | Trap checks     | --> | Responder       |
| collect()       |     | balance drop    |     | pause()         |
+-----------------+     +-----------------+     +-----------------+
                               |
                               v
                      +-----------------+
                      | Payload         |
                      | - previous      |
                      | - current       |
                      | - drained       |
                      | - percent       |
                      +-----------------+
## How It Works

collect() — reads current balance of protected contract (ETH or ERC20)

shouldRespond() — compares with previous balance, triggers if drop > 20%

pause(bytes) — decodes payload, emits event, pauses protocol

## Configuration

ethereum_rpc = "https://ethereum-hoodi-rpc.publicnode.com"
eth_chain_id = 560048

[traps.treasury_drain]
path = "out/TreasuryRapidDrainDetector.sol/TreasuryRapidDrainDetector.json"
response_contract = "0x43689d3C0301592AC79C3635B2dEBF4835cF3f5a"
response_function = "pause(bytes)"
block_sample_size = 2
cooldown_period_blocks = 10
min_number_of_operators = 1
max_number_of_operators = 1
private_trap = false
whitelist = []

## Security Features

Authorized executors — only whitelisted addresses can trigger pause

Ownable — contract owner can add/remove executors

Upgradable executor list — addExecutor() / removeExecutor()

4-param payload — full context for response

## Production Readiness

Before mainnet deployment:

Replace INITIAL_EXECUTOR with official Drosera executor address

Remove test EOA from authorized executors

Consider using multisig as owner

Set appropriate cooldown_period_blocks (10-100 recommended)

## Limitations (Explicit)

Cooldown is managed by Drosera, not inside the trap

Threshold is hardcoded (20%) — change requires redeployment

No emergency withdraw or multi-step response (out of scope)

## Use Case Example

Protocol treasury holds 1,000 ETH. Attacker gains private key access and starts draining. In one block, 300 ETH (>20%) is withdrawn. Trap triggers -> pause() -> remaining 700 ETH saved.

## Test Results

[PASS] testEmptyData()
[PASS] testNoDrain()
[PASS] testRapidDrain()
[PASS] testRapidDrainWithPayload()

## Deployment

Network	Hoodi
Chain ID	560048
Trap Address	0x133d815B79D8ED4f824c77aF0E739bF75f19B56D
Responder Address	0x43689d3C0301592AC79C3635B2dEBF4835cF3f5a
License
MIT
