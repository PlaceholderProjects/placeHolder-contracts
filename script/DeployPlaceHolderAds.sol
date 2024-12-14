// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "../src/PlaceHolderAds.sol";
import "forge-std/Script.sol";

contract DeployPlaceHolderAds is Script {
    function run() external {
        uint256 privateKey = vm.envUint("LOCAL_PRIVATE_KEY");

        vm.startBroadcast(privateKey);

        PlaceHolderAds placeholderAds = new PlaceHolderAds();
        console.log("Contract deployed at:", address(placeholderAds));

        // Write contract address to a file in the script directory
        vm.writeFile(
            "./script/contract-address.txt",
            addressToString(address(placeholderAds))
        );

        vm.stopBroadcast();
    }

    function addressToString(address _addr)
        internal
        pure
        returns (string memory)
    {
        bytes20 value = bytes20(_addr);
        bytes16 hexAlphabet = "0123456789abcdef";
        bytes memory str = new bytes(42);
        str[0] = "0";
        str[1] = "x";
        for (uint256 i = 0; i < 20; i++) {
            str[2 + i * 2] = hexAlphabet[uint8(value[i] >> 4)];
            str[3 + i * 2] = hexAlphabet[uint8(value[i] & 0x0f)];
        }
        return string(str);
    }
}
