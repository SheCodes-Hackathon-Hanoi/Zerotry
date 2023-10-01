// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract AnimalsFunding {
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
        uint256 rate;
    }

    mapping(uint256 => Campaign)  public campaigns;

    uint256 public numberOfCampaigns = 0;

    function createCampaign(string memory _title, string memory _description, uint256 _target, uint256 _deadline, string memory _image, uint256 _rate) public returns (uint256) {
        Campaign storage campaign = campaigns[numberOfCampaigns];

        require(campaign.deadline < block.timestamp, "The deadline should be a date in futute");

        campaign.owner = msg.sender;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;
        campaign.rate = _rate;

        
        numberOfCampaigns++;

        return numberOfCampaigns-1;
    }

    function donateTocampaign (uint256 _id) public payable {
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_id];

        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent, ) = payable(campaign.owner).call{value: amount}("");

        if(sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }

    }

    function withdraw(uint256 _id) public {
        require(msg.sender == campaigns[_id].owner, "Not authorized!");
        require(block.timestamp > campaigns[_id].deadline, "Cannot withdraw!");

        Campaign storage campaign = campaigns[_id];

        uint256 amountToSend = campaign.amountCollected;

        // Transfer the funds to the owner and update the withdrawal flag
        (bool success,) = msg.sender.call{value: amountToSend}("");
        require(success, "unable to send!");

    }

    function getDonators(uint256 _id) view public returns(address[] memory, uint256[] memory){
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    function getcampaigns() public view returns (Campaign[] memory) {
        Campaign[] memory allcampaigns = new Campaign[](numberOfCampaigns);

        for(uint i = 0; i< numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];

            allcampaigns[i] = item;
        }

        return allcampaigns;
    }
    
}