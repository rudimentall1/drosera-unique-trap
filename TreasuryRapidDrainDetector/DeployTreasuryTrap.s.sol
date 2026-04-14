// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/TreasuryRapidDrainDetector.sol";

contract DeployTreasuryTrap is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        TreasuryRapidDrainDetector detector = new TreasuryRapidDrainDetector(
            0xc55ae4780895d945542143568b4B27c2aCE087EE,
            0x0000000000000000000000000000000000000000,
            false
        );
        
        console.log("TreasuryRapidDrainDetector deployed to:", address(detector));
        
        vm.stopBroadcast();
    }
}
