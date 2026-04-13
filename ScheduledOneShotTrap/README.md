# ScheduledOneShotTrap

## Contract Address
`0x4FB582e1aEA38F8Ce109061A0DDf466AD0cf18Ec` (Hoodi, chainId: 560048)

## Core Logic
```solidity
function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
    if (data.length == 0 || data[0].length == 0) return (false, bytes(""));
    if (data.length < 2 || data[1].length == 0) return (false, bytes(""));
    
    uint256 newest = abi.decode(data[0], (uint256));
    uint256 previous = abi.decode(data[1], (uint256));
    bool trigger = previous <= SCHEDULED_BLOCK && newest > SCHEDULED_BLOCK;
    
    return trigger ? (true, bytes("")) : (false, bytes(""));
}
Configuration
Use drosera.correct.toml for Drosera integration.

Test Results
All 7 tests passed.

License
MIT
