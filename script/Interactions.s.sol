// SPDX-License-Identifier: MIT

// Fund Script
// Withdraw Script

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 SEND_VALUE = 0.01 ether;
    function fundFundMe(address mostRecentDeploy) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeploy)).fund{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("funded FundMe with %s", SEND_VALUE);
    }
    function run() external {
        address mostRecentDeploy = DevOpsTools.get_most_recent_deployment(
            "FundMe", 
            block.chainid);
        vm.startBroadcast();
        fundFundMe(mostRecentDeploy);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {
        function withdrawFundMe(address mostRecentDeploy) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeploy)).withdraw();
        vm.stopBroadcast();
    }
    function run() external {
        address mostRecentDeploy = DevOpsTools.get_most_recent_deployment(
            "FundMe", 
            block.chainid);
        vm.startBroadcast();
        withdrawFundMe(mostRecentDeploy);
        vm.stopBroadcast();
    }
}