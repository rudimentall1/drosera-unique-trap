// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/TreasuryRapidDrainDetector.sol";

contract MockTreasury {
    uint256 public balance;
    
    receive() external payable {
        balance = address(this).balance;
    }
}

contract TreasuryRapidDrainDetectorTest is Test {
    TreasuryRapidDrainDetector detector;
    MockTreasury treasury;
    
    function setUp() public {
        treasury = new MockTreasury();
        detector = new TreasuryRapidDrainDetector(
            address(treasury),
            address(0),
            false
        );
    }
    
    function testNoDrain() public {
        vm.deal(address(treasury), 1000 ether);
        
        uint256 previousBalance = address(treasury).balance;
        
        vm.prank(address(treasury));
        payable(address(0)).transfer(100 ether);
        
        uint256 currentBalance = address(treasury).balance;
        
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encode(currentBalance);
        data[1] = abi.encode(previousBalance);
        
        (bool should, ) = detector.shouldRespond(data);
        assert(!should);
    }
    
    function testRapidDrain() public {
        vm.deal(address(treasury), 1000 ether);
        
        uint256 previousBalance = address(treasury).balance;
        
        vm.prank(address(treasury));
        payable(address(0)).transfer(300 ether);
        
        uint256 currentBalance = address(treasury).balance;
        
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encode(currentBalance);
        data[1] = abi.encode(previousBalance);
        
        (bool should, ) = detector.shouldRespond(data);
        assert(should);
    }
    
    function testEmptyData() public view {
        bytes[] memory data = new bytes[](1);
        data[0] = "";
        
        (bool should, ) = detector.shouldRespond(data);
        assert(!should);
    }
    
    function testRapidDrainWithPayload() public {
        vm.deal(address(treasury), 1000 ether);
        
        uint256 previousBalance = address(treasury).balance;
        
        vm.prank(address(treasury));
        payable(address(0)).transfer(300 ether);
        
        uint256 currentBalance = address(treasury).balance;
        uint256 drained = previousBalance - currentBalance;
        uint256 percent = (drained * 100) / previousBalance;
        
        bytes[] memory data = new bytes[](2);
        data[0] = abi.encode(currentBalance);
        data[1] = abi.encode(previousBalance);
        
        (bool should, bytes memory payload) = detector.shouldRespond(data);
        assert(should);
        
        (uint256 decodedPrev, uint256 decodedCurr, uint256 decodedDrained, uint256 decodedPercent) = 
            abi.decode(payload, (uint256, uint256, uint256, uint256));
        
        assert(decodedPrev == previousBalance);
        assert(decodedCurr == currentBalance);
        assert(decodedDrained == drained);
        assert(decodedPercent == percent);
    }
}
