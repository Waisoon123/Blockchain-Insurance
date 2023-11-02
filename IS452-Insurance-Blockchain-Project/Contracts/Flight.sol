// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FlightStatus {
    struct Flight {
        string status;
    }
    
    // Define a mapping to store FlightId to Flight details.
    mapping(uint256 => Flight) private flights;

    // Constructor to initialize the mapping with hardcoded data.
    constructor() {
        flights[787] = Flight("Delayed");
        flights[112] = Flight("Arrived");
        // flights[232] = Flight("Baggage");
        // flights[333] = Flight("Evacuation in progress");
        // flights[444] = Flight("Cancelled due to natural disaster");
        // Add more key-value pairs as needed.
    }

    // Function to query the status of a given FlightId.
    function getStatus(uint256 flightId) public view returns (string memory) {
        return flights[flightId].status;
    }

    // Function to query the status of all flights.
    function getStatusAllFlights() public view returns (uint256[] memory, string[] memory) {
        uint256[] memory flightIds = new uint256[](2); // Update the size as needed
        string[] memory statuses = new string[](2); // Update the size as needed
        flightIds[0] = 787;
        flightIds[1] = 112;
        statuses[0] = flights[787].status;
        statuses[1] = flights[112].status;
        // Add more flight numbers and statuses as needed.
        return (flightIds, statuses);
    }

    // Function to processClaims
    function processClaims() public payable {
        
    }
}
