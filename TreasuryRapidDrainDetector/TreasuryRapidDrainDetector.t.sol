// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/TreasuryRapidDrainDetector.sol";

contract MockTreasury {
    uint256 public balance;
    
    function setBalance(uint256 _balance) external {
        balance = _balance;
    }
    
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
        // Устанавливаем баланс через vm.deal (способ forge)
        vm.deal(address(treasury), 1000 ether);
        
        uint256 previousBalance = address(treasury).balance;
        
        // Снимаем 10% через vm.prank
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
        // Устанавливаем баланс через vm.deal
        vm.deal(address(treasury), 1000 ether);
        
        uint256 previousBalance = address(treasury).balance;
        
        // Снимаем 30% через vm.prank
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
}
