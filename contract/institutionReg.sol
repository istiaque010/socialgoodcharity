// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract institutionReg {
    struct CharityOrganization {
        string institutionName;
        string regNumber;
        string country;
        string mission;
        string addressLine;
        string phoneNumber;
        string email;
        string institutionType;
        string management;
        string purpose;
        string activities;
        string financialInfo;
        string Governance;
        bool isRegistered;
    }

    // Address of the contract creator (admin)
    address public admin;

    // Mapping to store charity organization information by their Ethereum address
    mapping(address => CharityOrganization) public charities;

    // Event to notify when a new charity organization registers
    event CharityRegistered(address indexed orgAddress, string institutionName);

    // Modifier to restrict access to only the contract admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can perform this action");
        _;
    }

    // Modifier to restrict access to only registered charity organizations
    modifier onlyRegisteredCharities() {
        require(charities[msg.sender].isRegistered, "You are not a registered charity organization");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    // Function to register a new charity organization
    function registerCharity(
        string memory _institutionName,
        string memory _regNumber,
        string memory _country,
        string memory _mission,
        string memory _addressLine,
        string memory _phoneNumber,
        string memory _email,
        string memory _institutionType,
        string memory _management,
        string memory _purpose,
        string memory _activities,
        string memory _financialInfo,
        string memory _governance
    ) external {
        require(!charities[msg.sender].isRegistered, "Charity organization is already registered");
        require(bytes(_institutionName).length > 0, "Institution Name must not be empty");

        CharityOrganization memory newCharity = CharityOrganization({
            institutionName: _institutionName,
            regNumber: _regNumber,
            country: _country,
            mission: _mission,
            addressLine: _addressLine,
            phoneNumber: _phoneNumber,
            email: _email,
            institutionType: _institutionType,
            management: _management,
            purpose: _purpose,
            activities: _activities,
            financialInfo: _financialInfo,
            Governance: _governance,
            isRegistered: true
        });

        charities[msg.sender] = newCharity;
        emit CharityRegistered(msg.sender, _institutionName);
    }

    // Function to update charity organization information
    function updateCharity(
        string memory _institutionName,
        string memory _regNumber,
        string memory _country,
        string memory _mission,
        string memory _addressLine,
        string memory _phoneNumber,
        string memory _email,
        string memory _institutionType,
        string memory _management,
        string memory _purpose,
        string memory _activities,
        string memory _financialInfo,
        string memory _governance
    ) external onlyRegisteredCharities {
        require(bytes(_institutionName).length > 0, "Institution Name must not be empty");
        
        CharityOrganization storage charity = charities[msg.sender];
        charity.institutionName = _institutionName;
        charity.regNumber = _regNumber;
        charity.country = _country;
        charity.mission = _mission;
        charity.addressLine = _addressLine;
        charity.phoneNumber = _phoneNumber;
        charity.email = _email;
        charity.institutionType = _institutionType;
        charity.management = _management;
        charity.purpose = _purpose;
        charity.activities = _activities;
        charity.financialInfo = _financialInfo;
        charity.Governance = _governance;
    }

    // Function to unregister a charity organization
    function unregisterCharity() external onlyRegisteredCharities {
        delete charities[msg.sender];
    }

    // Function to check if a charity organization is registered
    function isCharityRegistered(address _orgAddress) external view returns (bool) {
        return charities[_orgAddress].isRegistered;
    }

    // Function to get charity organization information
    function getCharityInfo(address _orgAddress)
        external
        view
        returns (
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory,
            string memory
        )
    {
        require(charities[_orgAddress].isRegistered, "Charity organization is not registered");
        CharityOrganization memory charity = charities[_orgAddress];
        return (
            charity.institutionName,
            charity.regNumber,
            charity.country,
            charity.mission,
            charity.addressLine,
            charity.phoneNumber,
            charity.email,
            charity.institutionType,
            charity.management,
            charity.purpose,
            charity.activities,
            charity.financialInfo,
            charity.Governance
        );
    }

    // Function to transfer the contract ownership to a new admin (only current admin can call this)
    function transferAdmin(address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0), "Invalid address");
        admin = _newAdmin;
    }

    // Function to check if an address is registered as a charity organization
    function isRegIstitute(address _orgAddress) external view returns (bool) {
        return charities[_orgAddress].isRegistered;
    }
}
