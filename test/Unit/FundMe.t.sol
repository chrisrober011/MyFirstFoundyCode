// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    uint256 number = 1;
    uint256 send_Value = 0.1 ether;
    address USER = makeAddr("user");
    uint256 StartBalance = 10 ether;
    FundMe fundMe;

    function setUp() external {
        vm.deal(USER, StartBalance);
       DeployFundMe deployFundMe = new DeployFundMe();
       fundMe = deployFundMe.run();
    }

    function testMinimumUSD() public {
        assertEq(fundMe.MINIMUM_USD(), 5e18);
    }

    function testiowner() public {
       // console.log(fundMe.i_owner());
       // console.log(msg.sender)
        assertEq(fundMe.getOwner(), msg.sender);
    }

    function testPriceFeedVirsion() public {
        assertEq(fundMe.getVersion(), 4);
    }

    function testrevertDontsendEnoughEth() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testUpdateFundedDataStruckter() public {
        vm.prank(USER); // The next tx will send By User We creat up
        fundMe.fund{value: send_Value}();

        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, send_Value);
    }

    function testAddsfunderToArrayFunder() public {
        vm.prank(USER); // The next tx will send By User We creat up
        fundMe.fund{value: send_Value}();
        
        address funder = fundMe.getFunders(0);
        assertEq(funder, USER);
    }

    modifier funded () {
        vm.prank(USER); // The next tx will send By User We creat up
        fundMe.fund{value: send_Value}();
        _;
    }

    function testOnlyOwnerCanWithdraw () public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithSingleFunder() public funded {
        //Arange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFundedBalance = address(fundMe).balance;

        //Action
        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        //Assert
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        uint256 endingFundMeBalance = address(fundMe).balance;
        assertEq(endingFundMeBalance, 0);
        assertEq(startingOwnerBalance + startingFundedBalance, endingOwnerBalance);
    }

    function testWithdrawForSingleFunder() public {
        //Arrange
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFunderBalance = address(fundMe).balance;

        //ِAction
        vm.prank(fundMe.getOwner());
        fundMe.withdrawcheaper();

        //Assert
        uint256 endingFunderBalance = address(fundMe).balance;
        uint256 endingOwnerBalance = fundMe.getOwner().balance;
        assertEq(endingFunderBalance, 0);
        assertEq(startingFunderBalance + startingOwnerBalance, endingOwnerBalance);
    }

    function testWithdrawForMultipleFunders() public {
        // Arraw
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;
        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++){
        // vm.prank new address
        // vm.deal new address
        // address()
        hoax(address(i),send_Value);
        fundMe.fund{value: send_Value}();
        }
        //Action
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFunderBalance = address(fundMe).balance;

        vm.startPrank(fundMe.getOwner());
        fundMe.withdraw();

        //Assert
        assert(address(fundMe).balance == 0);
        assert(startingOwnerBalance + startingFunderBalance == fundMe.getOwner().balance);
    }

    function testWithdrawForMultipleFunderscheaper() public {
        //array of funder
        uint160 NumberOfFunder = 10;
        uint160 StartingFunderIndex = 1;
        for(uint160 i = NumberOfFunder; i < StartingFunderIndex; i++){
            // vm.prank new address
            // vm.deal new address
            // address()
            hoax(address(i),send_Value);
            fundMe.fund{value: send_Value}();
        }
        //Action
        uint256 startingOwnerBalance = fundMe.getOwner().balance;
        uint256 startingFunderBalance = address(fundMe).balance;

        //Assert
        assert(address(fundMe).balance == 0);
        assert(startingOwnerBalance + startingFunderBalance == fundMe.getOwner().balance);
    }

}