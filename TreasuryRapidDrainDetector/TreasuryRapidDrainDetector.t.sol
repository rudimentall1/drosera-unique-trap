// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/TreasuryRapidDrainDetector.sol";

contract MockTreasury {
    uint256 public balance;
    function setBalance(uint256 _balance) external { balance = _balance; }
    receive() external payable { balance = address(this).balance; }
}

contract TreasuryRapidDrainDetectorTest is Test {
    TreasuryRapidDrainDetector detector;
    MockTreasury treasury;
    
    function setUp() public {
        treasury = new MockTreasury();
        treasury.setBalance(1000 ether);
        detector = new TreasuryRapidDrainDetector(
            address(treasury),
            address(0),
            false
        );
    }
    
    function testNoDrain() public view {
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encode(900 ether);
        data[1] = abi.encode(1000 ether);
        
        (bool should, ) = detector.shouldRespond(data);
        assert(!should);
    }
    
    function testRapidDrain() public view {
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encode(700 ether);
        data[1] = abi.encode(1000 ether);
        
        (bool should, ) = detector.shouldRespond(data);
        assert(should);
    }
    
    function testEmptyData() public view {
        bytes[] memory data = new bytes[](1);
        data[0] = "";
        
        (bool should, ) = detector.shouldRespond(data);
        assert(!should);
    }
}
