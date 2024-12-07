// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract PlaceHolderAds {
    struct Ad {
        address publisher;
        string imageIpfsUrl;
        string name;
        string text;
        uint256 timestamp;
        bool isActive;
        uint256 reputationScore;
    }

    uint256 private adCounter;
    mapping(uint256 => Ad) public ads;
    mapping(address => uint256[]) public publisherAds;

    event AdPublished(
        address indexed publisher,
        string imageIpfsUrl,
        string name,
        string text,
        uint256 timestamp,
        bool isActive,
        uint256 reputationScore
    );
    event ReputationScoreUpdated(
        address indexed publisher,
        string imageIpfsUrl,
        string name,
        string text,
        uint256 timestamp,
        bool isActive,
        uint256 reputationScore
    );
    event AdStatusChanged(
        address indexed publisher,
        string imageIpfsUrl,
        string name,
        string text,
        uint256 timestamp,
        bool isActive,
        uint256 reputationScore
    );

    modifier adExists(uint256 _adId) {
        require(_adId > 0 && _adId <= adCounter, "Ad does not exist");
        _;
    }

    modifier onlyAdOwner(uint256 _adId) {
        require(ads[_adId].publisher == msg.sender, "Not ad owner");
        _;
    }
    modifier onlyIssuer() {
        require(
            msg.sender == 0x180c5f2aBF35442Fb4425A1edBF3B5faDFc2208D,
            "Not issuer"
        );
        _;
    }

    function publishAd(
        string calldata _imageIpfsUrl,
        string calldata _name,
        string calldata _text
    ) external returns (uint256) {
        adCounter += 1;
        uint256 newAdId = adCounter;

        ads[newAdId] = Ad({
            publisher: msg.sender,
            imageIpfsUrl: _imageIpfsUrl,
            name: _name,
            text: _text,
            timestamp: block.timestamp,
            isActive: true,
            reputationScore: uint256(0)
        });

        publisherAds[msg.sender].push(newAdId);

        emit AdPublished(
            msg.sender,
            _name,
            _text,
            _imageIpfsUrl,
            block.timestamp,
            ads[newAdId].isActive,
            ads[newAdId].reputationScore
        );

        return newAdId;
    }

    function updateReputationScore(
        address _publisher,
        uint256 _reputationScore
    ) external onlyIssuer {
        uint256 _adId = getPublisherAds(_publisher)[0];

        ads[_adId].reputationScore = _reputationScore;

        emit ReputationScoreUpdated(
            _publisher,
            ads[_adId].imageIpfsUrl,
            ads[_adId].name,
            ads[_adId].text,
            ads[_adId].timestamp,
            ads[_adId].isActive,
            _reputationScore
        );
    }

    function toggleAdStatus(address _publisher) external onlyIssuer {
        uint256 _adId = getPublisherAds(_publisher)[0];

        ads[_adId].isActive = false;

        emit AdStatusChanged(
            ads[_adId].publisher,
            ads[_adId].imageIpfsUrl,
            ads[_adId].name,
            ads[_adId].text,
            ads[_adId].timestamp,
            ads[_adId].isActive,
            ads[_adId].reputationScore
        );
    }

    function getAd(
        uint256 _adId
    )
        external
        view
        adExists(_adId)
        returns (
            address publisher,
            string memory imageIpfsUrl,
            string memory name,
            string memory text,
            uint256 timestamp,
            bool isActive
        )
    {
        Ad memory ad = ads[_adId];
        return (
            ad.publisher,
            ad.imageIpfsUrl,
            ad.name,
            ad.text,
            ad.timestamp,
            ad.isActive
        );
    }

    function getPublisherAds(
        address _publisher
    ) public view returns (uint256[] memory) {
        return publisherAds[_publisher];
    }

    // Returns all ads in a single array of Ad structs
    function getAllAds() external view returns (Ad[] memory) {
        uint256 count = adCounter;
        Ad[] memory allAds = new Ad[](count);

        for (uint256 i = 1; i <= count; i++) {
            allAds[i - 1] = ads[i];
        }

        return allAds;
    }
}
