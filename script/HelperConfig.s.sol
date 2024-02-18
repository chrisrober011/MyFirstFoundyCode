// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/Mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
NetworkConfig public activeNetwokConfig;
uint8 public constant DECIMALS = 8;
int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed; //ETH/USD Spolia price
    }

    constructor() {
        if (block.chainid == 1155111) {
            activeNetwokConfig = getSpoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetwokConfig = getMainEthConfig();
        }
        {
            activeNetwokConfig = getOrCreatAnvilEthConfig();
        }
    }

    function getSpoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory SpoliaConfig = NetworkConfig({priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306});
        return SpoliaConfig;
    }

        function getMainEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainEthConfig = NetworkConfig({priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419});
        return mainEthConfig;
    }

    function getOrCreatAnvilEthConfig() public returns (NetworkConfig memory anvilNetworkConfig){
        if (activeNetwokConfig.priceFeed != address(0)) {
            return activeNetwokConfig;
        }
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();
        NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mockPriceFeed)});
        return anvilConfig;

    }
}

