# 🚀 ScheduledOneShotTrap

A one-time scheduled execution trap for the Drosera network.

## 📋 Features
- ✅ **One-shot execution** - Triggers only once
- ✅ **Rising edge logic** - Safe, non-spamming
- ✅ **Drosera compatible** - Full ITrap implementation
- ✅ **Tested & Verified** - Working on Sepolia

## 🎯 Deployment Details
- **Address:** `0x2e6E9618786fF2AFCa7d74fb874FE289035210F5`
- **Network:** Sepolia (11155111)
- **Trigger Block:** 1,856,179 ✓ TRIGGERED
- **Transaction:** `0xda03da63de649cefd2b9f79de2194b8103ada0121e7d8bf822678e41b05498b8`
- **Etherscan:** https://sepolia.etherscan.io/address/0x2e6E9618786fF2AFCa7d74fb874FE289035210F5

## ⚙️ Configuration
See `trap2.json` for Drosera integration.

## 🔧 Code
```solidity
function shouldRespond(bytes[] calldata data) external pure override returns (bool, bytes memory) {
    if (data.length == 0 || data[0].length == 0) return (false, bytes(""));
    uint256 newestSample = abi.decode(data[0], (uint256));
    if (data.length < 2) return (false, bytes(""));
    uint256 previousSample = abi.decode(data[1], (uint256));
    bool triggerCondition = previousSample <= SCHEDULED_BLOCK && newestSample > SCHEDULED_BLOCK;
    return triggerCondition ? (true, abi.encode(newestSample)) : (false, bytes(""));
}
