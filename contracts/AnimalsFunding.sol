// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract AnimalsFunding {
    struct Campaign {
        address creator;
        string name;
        string description;
        uint256 goal;
        uint256 endTime;
        uint256 rate;
        string image;
        uint256 totalFunding;
        address[] donor;
        uint256[] donations;
        
    }

    mapping(uint256 => Campaign)  public campaigns;

    uint256 public numberOfCampaigns = 0;

    function createCampaign(string memory _name, string memory _description, uint256 _goal, uint256 _endTime, string memory _image, uint256 _rate) public returns (uint256) {
        Campaign storage campaign = campaigns[numberOfCampaigns];

        require(campaign.endTime < block.timestamp, "The End Time should be a date in futute");

        campaign.creator = msg.sender;
        campaign.name = _name;
        campaign.description = _description;
        campaign.goal = _goal;
        campaign.endTime = _endTime;
        campaign.rate = _rate;
        campaign.totalFunding = 0;
        campaign.image = _image;
        

        
        numberOfCampaigns++;

        return numberOfCampaigns-1;
    }

    function donateToCampaign (uint256 campaignId) public payable {
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[campaignId];

        campaign.donor.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent, ) = payable(campaign.creator).call{value: amount}("");

        if(sent) {
            campaign.totalFunding = campaign.totalFunding + amount;
        }

    }

    function withdrawCampaign(uint256 campaignId) public {
        require(msg.sender == campaigns[campaignId].creator, "Not authorized!");
        require(block.timestamp > campaigns[campaignId].endTime, "The campaign not be end");

        Campaign storage campaign = campaigns[campaignId];

        uint256 amountToSend = campaign.totalFunding;

        (bool success,) = msg.sender.call{value: amountToSend}("");
        require(success, "cannot send");

    }

    function getdonor(uint256 campaignId) view public returns(address[] memory, uint256[] memory){
        return (campaigns[campaignId].donor, campaigns[campaignId].donations);
    }

    function getAllCampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allcampaigns = new Campaign[](numberOfCampaigns);

        for(uint i = 0; i< numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];

            allcampaigns[i] = item;
        }

        return allcampaigns;
    }
    
}