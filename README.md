# Blockchain Project

## Table of Content
[Overview][##Overview]

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
The `InsurancePurchase.sol` smart contract is a key component of a blockchain-based travel delay insurance solution. It offers a platform for users to purchase insurance policies, submit claims, and manage their insurance-related activities in a decentralized and secure manner.

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

### Remix Environment

- Go to remix environment ide website - https://remix.ethereum.org/#lang=en&optimize=false&runs=200&evmVersion=null&version=soljson-v0.4.26+commit.4563c3fc.js&language=Solidity
- On the "WORKSPACES" panel, you will be able to locate a "Upload Files" option.
- Upload the three contracts
- Alternatively you can copy paste each file code directly onto the remix environment, with each in "Create new file" option.

## Usage
This scenario will bring you through how a traveller could get insured, submit a claim in the events of disturbance. The insurance company would then proceed with the verification of the insurance claims, verifying certain conditions. The Insurance company would require at least two validators to provide consensus on the validity of the claim. This claim also has to met certain conditions, such as it must be flight delayed or cancelled reason, the status must first be in pending in order for them to process, and also checking flight details to ensure that what the insured party claims is the truth before disbursing the insured amount to the account associated with the user.

### Deploy InsurancePurchase.sol
- Click on `InsurancePurchase.sol`, please ensure that the file is sucessfully compiled by the Solidity Compiler (Which should show a green tick indicator).
- Click on "Deploy & Run Transactions" tab located on the most left panel of remix environment.
- Click on "Deploy" to deploy the smart contract (Ensure that under the Account, it is the first address.)

### Deploy Flight.sol
- Click on `Flight.sol`
- Select a different address from the "account" (Use the second address)
- Select "Deploy"

### Purchasing an Insurance 
- Under the "Deployed Contracts", expand and view the functions.
- Expand further in the `purchaseInsurance` function.
- Fill in the necessary details. Insured Amount (10,000) - _timeOfPurchase (HHMM) format - dateOfPurchase and paymentDate format (DDMMYYYY)
- After all details are entered, ensure that the value is "100" and is in Wei. 
- Click on "Transact" 
- Expand the output and observe the details, a policyNumber is randomly generated for keeping track purpose. We would ned the `to` row, "InsurancePolicy.purchaseInsurance(string,uint256,uint256,uint256,uint256,uint256) and the address that we need to copy for deploying `InsuranceClaims.sol`.
- Submit a claim using the `submitClaim` function. (policyNumber generated in last output, 3, 787) - note that "3" refers to the reason code which points to "Flights Delayed or Cancelled", whereas "787" refers to the flight that was hardcoded in the storage.

### Checking if we have submitted a claim successfully
- Click on `getPolicyDetails` and expand it
- Fill in the policyNumber that was generated in the previous steps and call the function
- This function should return you (policyyNumber, reasoncode, flightNumber, reason, statusOfClaim)
- The default has status of the claim has been set to "Pending".

### Deployment of InsuranceClaims.sol
- Using the address that has been generated by the user when the `inusrancePurchase` function was called - this allows the `InsuranceClaims.sol` contract to interact with the instance. 
- Click on `InsuranceClaims.sol`
- Change to a differnt account address (to simulate insurance company entity) - Use the third address
- Ensure that the value is filled up to "10" and change the units to Ether (This is to simulate a pool, that stores funds to be disbursed to successful claims).
- Copy paste the `to` row insurancePolicyAddress that we have mentioned. 
- Fill in "2" in the RequiredQuorum parameters (This mean that we will have two validators) - This contract only simulates two validators that will reach a consensus that a valid claim has been made, only then funds will be disbursed. 
- Click on "Transact"
- You should notice that the balance inside the address should have 10 ETH balance.(The third address balance would be less of 10 ETH which has been transferred to this pool)

### Process the Claims
- Expand the `InsuranceClaims.sol` under the deployed contracts section.
- Change the address to the 4th address (this will act as the first validator) to confirm the claim, click "transact"
- Run the `confirmClaim` function with the policyNumber inputted.
- To check whether we have done the verification, run `hasConfirmed` function using the 3rd address, input the policyNumber and address (the 4th address in the address tab that we used for first validator role)
- Change to the 5th address (this will act as the second validator) to confirm the claim, click "transact"
- Run the `processClaims` with the policyNumber inputted. This will trigger a disbursement to the associated insured party wallet address.
- To check whether we have done the verification, run `hasConfirmed` function using the 3rd address, input the policyNumber and address (the 5th address in the address tab that we used for second validator role)
- After confirming that the requiredQuorum of set value 2 has been met, we can run the `processClaims` to disburse the fund, remember to change it back to the 3rd address.
- As reflected in the wallet address, the insured associated wallet address should have an increase of 4 eth, while the pool has deducted the disbursed amount from its balance as well.