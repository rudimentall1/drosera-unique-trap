# Drosera Unique Traps

Security-oriented Drosera trap implementations for detecting abnormal treasury activity and triggering automated response logic.

## Implementations

### TreasuryRapidDrainDetector

Detects a significant treasury balance reduction between observations.

Flow:

1. `collect()` reads the treasury balance.
2. `shouldRespond()` compares the current value with the previous observation.
3. A reduction above the configured threshold produces a response payload.
4. The responder can emit an event and invoke `pause()` through authorized executors.

The implementation uses `Ownable` and an explicit executor allowlist for response authorization.

### ScheduledOneShotTrap

A demonstration trap for scheduled, single-event execution based on block conditions.

## Verification

The repository currently documents 4/4 passing tests for the treasury detector implementation.

## Deployment

The README previously recorded Hoodi deployments for the trap and responder. Check the source and deployment configuration before relying on those addresses for a new deployment.

## Configuration

- `drosera-treasury.toml`

## Status

Experimental security infrastructure / protocol integration work.
