# Blockchain Project

## Overview

Our project leverages blockchain technology to revolutionize travel delay insurance. Traditional insurance methods often suffer from inefficiency, lengthy claims processing times, and a lack of transparency, resulting in customer dissatisfaction. Our decentralized solution, powered by smart contracts, aims to address these issues.

## Problem

- Traditional Insurance is inefficient with long claims processing times. 
- Lack of transparency in claims payments. 
- Customers waiting for weeks for compensation.

## Solution

Our blockchain-based travel delay insurance automates the insurance claiming process, improving efficiency, transparency, and security. It eliminates the need for a central authority and facilitates automated insurance policies and claims processing through smart contracts. This results in quicker settlements and a significant reduction in fraudulent activities.

## Key Benefits

- Improved efficiency and transparency. 
- Enhanced security and fraud resilience.
- Automated claims processing.
- Happier customers.

## Smart Contracts

### **InusrancePurchase.sol**
This smart contract is a key component of a blockchain-based travel delay insurance solution. It offers a platform for users to purchase insurance policies, submit claims, and manage their insurance-related activities in a decentralized and secure manner.

1. **Purchase Insurance Policies**

    - Users can purchase insurance policies by providing essential details such as their name, age, insured amount, and payment information.
    - The contract calculates the premium based on the insured amount and ensures that the payment is sufficient. (100 dollars = 10,000 dollars payout)
    - Each policy is assigned a unique policy number, and the relevant information is stored in the contract.

2. **Manage Policies**

    - Users can retrieve a list of their purchased insurance policies using their Ethereum address. (In this case in remix environment, it would be the address that deployed the contract)
    - The contract maintains a mapping of user addresses to their respective policy numbers, enabling efficient policy management.

3. **Submit Claims**

    - Users can submit insurance claims when they experience travel disruptions covered by the policy.
    - Claims include information such as the policy number, reason code, and flight ID.
    - Submitted claims are stored in the contract, allowing for transparent and secure processing.

4. **Claim Status Updates**

    - Authorized parties can update the status of a submitted claim. (Default status is pending when the insured submit a claim)
    - Updates should comply with specific authorization (insurance company) and validation checks


### **InusranceClaims.sol**
The `InsuranceClaims.sol` smart contract is a vital component of the blockchain-based travel delay insurance solution. This contract manages the processing of insurance claims in a transparent and secure manner, ensuring that valid claims are fairly adjudicated and processed.

1. **Integration with Insurance Policy and Validators**
   - The contract interfaces with the `InsurancePolicy.sol` contract to access policy and claim information.
   - It involves a group of validators who play a pivotal role in confirming claim decisions.

2. **Validator Consensus Mechanism**
   - Validators are required to reach a consensus (quorum) before a claim can be processed.
   - Validators are responsible for confirming the claim's status and reason.

3. **Claim Processing**
   - Users initiate claims by providing the policy number, reason code, and flight ID.
   - Claims are verified for validity, ensuring they meet the criteria for processing by the insurance company (This is represented by another Eth Address during deployment).

4. **Claim Status Updates**
   - Authorized parties can update the status of a claim, restricting the options to "Pending," "Rejected," and "Disbursed" for clarity and control.

5. **Disbursement of Funds**
   - The contract includes a function to disburse funds to users' wallet addresses when claims are approved and reach the "Disbursed" status.

##### Consensus and Security

- The contract enforces a consensus mechanism among validators, ensuring that claim decisions are made collectively and fairly.
- Validators play a crucial role in maintaining trust and transparency within the insurance system.

##### Integration with External Contracts

- The contract interfaces with the `InsurancePolicy.sol` contract to access policy and claim data.
- It leverages information from the `Flight.sol` contract when necessary for claim verification.

### **Flights.sol**

1. **Flight Information Storage**
   - The contract is responsible for storing essential flight information, including flight IDs, departure times, and destinations.
   - Flight data is securely recorded within immutable blockchain ledgers, ensuring transparency and reliability.

2. **Verification of Flight Status**
   - Users can query the contract to verify the status of a specific flight.
   - This capability is crucial for claim processing and ensuring that insurance policies are accurately applied.

3. **Integration with Insurance Contracts**
   - The contract seamlessly integrates with the `InsurancePolicy.sol` and `InsuranceClaims.sol` contracts.
   - It provides the necessary flight data required for processing insurance claims, streamlining the process.

#### Security and Transparency

- The use of blockchain technology guarantees the security and immutability of flight data.
- Flight information is accessible and transparent, contributing to the overall trustworthiness of the insurance system.
- Please note that in this project, all flight data are hardcoded as blockchain operates in a decentralized manner, you would need to use oracles or off chain data provider to dynamically retrieve flight data.

#### Streamlining Claim Processing

- The contract plays a pivotal role in processing insurance claims, as it provides essential flight data required for verification.
- Integration with external insurance contracts ensures a seamless and efficient insurance process.

## Getting Started

## Usage