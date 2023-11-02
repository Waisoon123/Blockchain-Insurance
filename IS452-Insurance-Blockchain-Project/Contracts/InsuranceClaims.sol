// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./InsurancePurchase.sol";
import "./Flight.sol";

contract InsuranceClaims {
    // Declare a reference to the InsurancePolicy contract
    InsurancePolicy private insurancePolicy;
    // Declare a reference to the Flight contract
    FlightStatus private flightStatus;

    // Define validators and quorum
    address[] public validators;
    // for now input requiredQuorum as 2 for the sake of project
    uint public requiredQuorum;
    mapping(uint => mapping(address => bool)) public hasConfirmed;

    constructor(address _insurancePolicyAddress, uint _requiredQuorum) payable {
        // Initialize the reference to the deployed InsurancePolicy contract
        insurancePolicy = InsurancePolicy(_insurancePolicyAddress);

        // Hardcode two validator addresses for now
        validators.push(0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db);  
        validators.push(0x78731D3Ca6b7E34aC0F824c42a7cC18A495cabaB);  

        requiredQuorum = _requiredQuorum;
    }

    // Psuedo-code Logic here

    // Utility function to check if the new status is valid.
    function isStatusValid(string memory newStatus) internal pure returns (bool) {
        // Assuming that only four types of status {Pending, Approved, Rejected, Disbursed} are allowed.
        return
            keccak256(abi.encodePacked(newStatus)) == keccak256(abi.encodePacked("Pending")) ||
            keccak256(abi.encodePacked(newStatus)) == keccak256(abi.encodePacked("Rejected")) ||
            keccak256(abi.encodePacked(newStatus)) == keccak256(abi.encodePacked("Disbursed"));
    }

    // Function to Withdraw Funds from this contract
    function withdrawFunds(address payable walletAddress) public {
        walletAddress.transfer(4 ether); // This is hardcoded to represent the 10,000
    }

    // Function to ProcessClaims which takes in policyID as a parameter;
    function processClaims(uint policyNumber) public payable {
    // Function first calls getClaimDetails to check the claim's status and reason
    (, , , string memory reasonText, string memory claimStatus) = insurancePolicy.getClaimDetails(policyNumber);

    // Check if string is "Delayed or Cancelled Flights," otherwise exit
    // Call UpdateStatus to actually update the status to "Rejected"
    require(keccak256(abi.encodePacked(reasonText)) == keccak256(abi.encodePacked("Delayed or Cancelled Flights")), "Claim reason is not 'Delayed or Cancelled Flights'");

    // Check if claim status is "Pending," otherwise exit
    require(keccak256(abi.encodePacked(claimStatus)) == keccak256(abi.encodePacked("Pending")), "Claim status is not 'Pending'");

    // Check consensus among validators
    uint confirmationCount = 0;
    for (uint i = 0; i < validators.length; i++) {
        if (hasConfirmed[policyNumber][validators[i]] == true) {
            confirmationCount++;
        }
    }

    // Ensure confirmation count equals or exceeds the required quorum
    require(confirmationCount >= requiredQuorum, "Insufficient confirmations");

    // If enough validators have confirmed, disburse funds
    (, , , , address userAddress) = insurancePolicy.getPolicyDetails(policyNumber);
    address payable walletAddress = payable(userAddress);
    // If all checks above pass, call the Withdraw function and disburse funds to the provided wallet address
    // Call UpdateStatus to actually update the status to "Disbursed"
    withdrawFunds(walletAddress);
    insurancePolicy.updateClaimStatus(policyNumber, "Disbursed");
}


    // Validators confirm their agreement
    function confirmClaim(uint policyNumber) public {
        (, , , , string memory claimStatus) = insurancePolicy.getClaimDetails(policyNumber);
        require(keccak256(abi.encodePacked(claimStatus)) == keccak256(abi.encodePacked("Pending")), "Claim status is not 'Pending'");
        require(!hasConfirmed[policyNumber][msg.sender], "You have already confirmed this claim.");

        // Record the confirmation
        hasConfirmed[policyNumber][msg.sender] = true;
    }
}