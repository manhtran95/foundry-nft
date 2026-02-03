// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DeployMoodNft} from "../script/DeployMoodNft.s.sol";
import {MoodNft} from "../src/MoodNft.sol";

contract DeployMoodNftTest is Test {
    DeployMoodNft public deployer;

    function setUp() public {
        deployer = new DeployMoodNft();
    }

    function testCanConvertSvgToImageUri() public view {
        string memory expectedUri = "data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iNTAwIiBoZWlnaHQ9IjUwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48dGV4dCB4PSIwIiB5PSIxNSIgZmlsbD0iYmxhY2siPllvdXIgYnJvd3NlciBkZWNvZGVkIHRoaXMhPC90ZXh0Pjwvc3ZnPg==";
        string memory svg = '<svg width="500" height="500" xmlns="http://www.w3.org/2000/svg"><text x="0" y="15" fill="black">Your browser decoded this!</text></svg>';
        string memory imageUri = deployer.svgToImageURI(svg);
        assert(keccak256(abi.encodePacked(imageUri)) == keccak256(abi.encodePacked(expectedUri)));
    }
}