// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract MoodNft is ERC721 {
    uint256 private sTokenCounter;
    string private sSadSvgImageUri;
    string private sHappySvgImageUri;

    error MoodNft__CantFlipMoodIfNotOwner();

    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private sTokenIdToMood;

    constructor(
        string memory sadSvgImageUri,
        string memory happySvgImageUri
    ) ERC721("Mood NFT", "MN") {
        sTokenCounter = 0;
        sSadSvgImageUri = sadSvgImageUri;
        sHappySvgImageUri = happySvgImageUri;
    }

    function mintNft() public {
        _safeMint(msg.sender, sTokenCounter);
        sTokenIdToMood[sTokenCounter] = Mood.HAPPY;
        sTokenCounter++;
    }

    function flopMood(uint256 tokenId) public {
        if (getApproved(tokenId) != msg.sender && ownerOf(tokenId) != msg.sender) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }
        if (sTokenIdToMood[tokenId] == Mood.HAPPY) {
            sTokenIdToMood[tokenId] = Mood.SAD;
        } else {
            sTokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    function _baseURI() internal pure override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        string memory imageUri;
        if (sTokenIdToMood[tokenId] == Mood.HAPPY) {
            imageUri = sHappySvgImageUri;
        } else {
            imageUri = sSadSvgImageUri;
        }

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    abi.encodePacked('{"name": "', name(), '", "description": "A mood NFT", "attributes": [{"trait_type": "Mood", "value": 100}], "image": "', imageUri, '"}')
                )
            )
        );

    }
}