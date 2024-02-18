// SPDX - License - Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";
import {FundFundMe, WithdrawFundMe} from "../../script/Interactions.s.sol";

contract InteractionsTest is Test {
    address USER = makeAddr("user");
    uint256 constant number = 1;
    uint256 constant send_Value = 0.01 ether;
    uint256 constant start_Balance = 10 ether;
    uint256 constant gas_Price = 1;
    FundMe fundMe;

    function setUp() external {
        DeployFundMe deploy = new DeployFundMe();
        fundMe = deploy.run();
        vm.deal(USER, start_Balance);
    }

    // function testUserCanFundInteractions() public {
    //     vm.prank(USER);
    //     vm.deal(USER, 1e18);
    //     FundFundMe fundFundMe = new FundFundMe();
    //     fundFundMe.fundFundMe(address(fundMe));

    //     address funder = fundMe.getFunders(0);
    //     assertEq(USER, funder);
    // }

    function testUserCanWithdrawInteractions() public {
        FundFundMe fundFundMe = new FundFundMe();
        fundFundMe.fundFundMe(address(fundMe));

        WithdrawFundMe withdrawFundMe = new WithdrawFundMe();
        withdrawFundMe.withdrawFundMe(address(fundMe));

        assert(address(fundMe).balance == 0);
    }
}
