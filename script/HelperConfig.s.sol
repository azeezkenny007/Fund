// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
contract HelperConfig is Script{
    uint8 public constant ETH_USD_DECIMALS = 8;
    int256 public constant ETH_USD_INITIAL_PRICE = 2000e8;

  
    struct NetworkConfig{
        address priceFeed_ETH_USD_ADDRESS;
    }

    NetworkConfig public activeNetworkConfig;

    constructor(){
        if(block.chainid == 11155111){
            activeNetworkConfig = getSepoliaEthConfig();
        }
        else if(block.chainid == 1){
            activeNetworkConfig = getEthMainnetConfig();
        }
        else{
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }
    function getSepoliaEthConfig() public pure returns(NetworkConfig memory){
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed_ETH_USD_ADDRESS: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoliaConfig;
    }

    function getEthMainnetConfig() public pure returns(NetworkConfig memory){
        NetworkConfig memory ethMainnetConfig = NetworkConfig({
            priceFeed_ETH_USD_ADDRESS: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return ethMainnetConfig;
    }



    function getOrCreateAnvilEthConfig() public returns(NetworkConfig memory){
        if(activeNetworkConfig.priceFeed_ETH_USD_ADDRESS != address(0)){
            return activeNetworkConfig;
        }
         vm.startBroadcast();
         MockV3Aggregator ethUsdPriceFeed = new MockV3Aggregator(ETH_USD_DECIMALS, ETH_USD_INITIAL_PRICE);
         vm.stopBroadcast();
         NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed_ETH_USD_ADDRESS: address(ethUsdPriceFeed)
         });
         return anvilConfig;
    }
}
    
