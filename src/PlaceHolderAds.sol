// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PlaceHolderAds {
    // Structs
    struct Ad {
        uint256 id;
        address publisher;
        string imageIpfsUrl;
        string name;
        string text;
        uint256 timestamp;
        bool isActive;
    }
    struct Publisher {
        address publisherAddress;
        uint256 totalAdsPublished;
        uint256 registrationTime;
        bool isRegistered;
    }
    uint256 private adCounter;
    mapping(uint256 => Ad) public ads;
    mapping(address => Publisher) public publishers;
    mapping(address => uint256[]) public publisherAds;

    event PublisherRegistered(
        address indexed publisherAddress,
        uint256 indexed timestamp
    );
    event AdPublished(
        uint256 indexed adId,
        address indexed publisher,
        string imageIpfsUrl,
        string name,
        uint256 timestamp
    );
    event AdStatusChanged(
        uint256 indexed adId,
        address indexed publisher,
        bool isActive
    );
    modifier onlyRegisteredPublisher() {
        require(publishers[msg.sender].isRegistered, "Not registered");
        _;
    }
    modifier adExists(uint256 _adId) {
        require(_adId < adCounter, "Ad does not exist");
        _;
    }
    modifier onlyAdOwner(uint256 _adId) {
        require(ads[_adId].publisher == msg.sender, "Not ad owner");
        _;
    }

    function registerPublisher() external {}
}
