// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/TreasuryResponder.sol";

contract DeployResponder is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        TreasuryResponder responder = new TreasuryResponder(
            0x133d815B79D8ED4f824c77aF0E739bF75f19B56D
        );
        
        console.log("TreasuryResponder deployed to:", address(responder));
        
        vm.stopBroadcast();
    }
}
