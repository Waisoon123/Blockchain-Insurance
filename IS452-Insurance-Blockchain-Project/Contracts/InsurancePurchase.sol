// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InsurancePolicy {
    // Insurers address
    address public authorizedAddress;

    struct Policy {
        string name;
        uint age;
        uint insuredAmount;
        uint paidPremiumAmount;
        uint timeOfPurchase;
        uint dateOfPurchase;
        uint paymentDate;
        bool active;
        address userAddress;
        uint policyNumber;
    }

    struct Claim {
        uint policyNumber;
        uint reasonCode;
        string status;
        uint flightID; // Add the flightID field
    }


    mapping(uint => Policy) private policies;
    mapping(uint => Claim) private claims;
    mapping(address => uint[]) private userPolicies;

    event PolicyPurchased(uint policyNumber, address userAddress, uint insuredAmount, uint premiumAmount, uint paymentDate);
    event ClaimSubmitted(uint policyNumber, uint reasonCode, string status);

    mapping(uint => string) private reasonCodeToText;

    constructor() {
        reasonCodeToText[1] = "Trip Cancellation";
        reasonCodeToText[2] = "Trip Interruption";
        reasonCodeToText[3] = "Delayed or Cancelled Flights";
        reasonCodeToText[4] = "Lost, Stolen, or Delayed Baggage";
        reasonCodeToText[5] = "Medical Emergencies";
        reasonCodeToText[6] = "Emergency Evacuation";
    }

    // Function to purchase an insurance policy by providing the required parameters
    function purchaseInsurance(
        string memory _name,
        uint _age,
        uint _insuredAmount,
        uint _timeOfPurchase,
        uint _dateOfPurchase,
        uint _paymentDate
    ) public payable {
        require(_insuredAmount > 0, "Insured amount must be greater than 0");

        uint policyNumber = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, userPolicies[msg.sender].length))) % 1000000;

        uint premiumAmount = (_insuredAmount / 10000) * 100;
        require(msg.value >= premiumAmount, "Premium amount must be sufficient");

        Policy storage newPolicy = policies[policyNumber];
        newPolicy.name = _name;
        newPolicy.age = _age;
        newPolicy.insuredAmount = _insuredAmount;
        newPolicy.paidPremiumAmount = premiumAmount;
        newPolicy.timeOfPurchase = _timeOfPurchase;
        newPolicy.dateOfPurchase = _dateOfPurchase;
        newPolicy.paymentDate = _paymentDate;
        newPolicy.active = true;
        newPolicy.userAddress = msg.sender;
        newPolicy.policyNumber = policyNumber;

        userPolicies[msg.sender].push(policyNumber);

        emit PolicyPurchased(policyNumber, msg.sender, _insuredAmount, premiumAmount, _paymentDate);
    }

    // Function to retrieve a user's list of policy numbers
    function getUserPolicies(address _userAddress) public view returns (uint[] memory) {
        // Error handling to check if user has purchased any insurance to call the function
        require(userPolicies[_userAddress].length > 0, "No Insurance has been purchased under this account...");
        return userPolicies[_userAddress];
    }

    // Define a dynamic array to store all submitted claims
    Claim[] private allClaims;

    // I think we are missing one require statement here which is to check for the FlightID whether if it is a valid one. (Error checking that is missing here in this function)
    function submitClaim(uint _policyNumber, uint _reasonCode, uint _flightID) public {
        require(policies[_policyNumber].active, "Policy is not active");
        Policy storage policy = policies[_policyNumber];
        require(policy.userAddress == msg.sender, "This policy is not under you, unable to submit claim request...");

        Claim storage newClaim = claims[_policyNumber];
        newClaim.policyNumber = _policyNumber;
        newClaim.reasonCode = _reasonCode;
        newClaim.status = "Pending";
        newClaim.flightID = _flightID; 

        // Add the submitted claim to the allClaims array
        allClaims.push(newClaim);

        emit ClaimSubmitted(_policyNumber, _reasonCode, "Pending");
    }


    // Users can query the details of a claim by providing the policy number
    function getClaimDetails(uint _policyNumber) public view returns (uint, uint, uint, string memory, string memory) {
        // Error Handling - User who has not submitted a claim cannot call this function
        require(claims[_policyNumber].policyNumber > 0, "No claim has been submitted yet. Please submit a claim first...");
        Claim storage claim = claims[_policyNumber];
        // Policy storage policy = policies[_policyNumber];
        // require(policy.userAddress == msg.sender, "This policy is not under you, unable to provide claim details to you...");
        return (claim.policyNumber, claim.reasonCode, claim.flightID, reasonCodeToText[claim.reasonCode], claim.status);
    }


    // Function to retrieve policy details based on policy ID
    function getPolicyDetails(uint _policyNumber) public view returns (string memory, uint _age, uint _insuredAmount, uint _dateOfPurchase, address) {
        Policy storage policy = policies[_policyNumber];
        require(policy.active, "Policy is not active");
        // This checks for the address -- if its not the intended insurer, it cannot get back the details
        // require(policy.userAddress == msg.sender, "This policy is not under you, unable to provide policy details to you...");
        return (policy.name, policy.age, policy.insuredAmount, policy.dateOfPurchase, policy.userAddress);
    }

    // Testing function for update to be pass back here
    function updateClaimStatus(uint _policyNumber, string memory _newStatus) public {
    Policy storage policy = policies[_policyNumber];
    require(policy.active, "Policy is not active");
    
    // Check if a claim requests exists for the policy;
    (uint claimPolicyNumber, , , , string memory claimStatus) = getClaimDetails(_policyNumber);
    require(claimPolicyNumber == _policyNumber && bytes(claimStatus).length > 0, "No claim has been submitted for this policy");

    require(policy.userAddress != msg.sender, "Only authorized parties are allowed to make changes to the claim status");
    // Perform any necessary checks to ensure the update is valid, e.g., authorization and validation of newStatus.
    // Then, update the claim status.
    Claim storage claim = claims[_policyNumber];
    claim.status = _newStatus;
    }

}
