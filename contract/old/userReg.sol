// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CharityPlatform {
    struct User {
        address userAddress;
        string userID;
        string fullName;
        uint256 dateOfBirth;
        string gender;
        string userType;
        string orgAddress;
        string instituteRole;
        string KYCstatus;
        string userStatus;
        string addressLine;
        string phoneNumber;
        string email;
        string country;
        string nationality;
        string nid; // National Identification Number
        string maritalStatus;
        string educationLevel;
        string incomeLevel;
        string employmentStatus;
        string taxStatus;
        string communicationPref;
        bool consentPermission;
        bool isRegistered;
    }

    // Address of the contract creator (admin)
    address public admin;

    // Mapping to store user information by their Ethereum address
    mapping(address => User) public users;

    // Event to notify when a new user registers
    event UserRegistered(address indexed userAddress, string userID, string fullName, string email);

    // Modifier to restrict access to only the contract admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can perform this action");
        _;
    }

    // Modifier to restrict access to only registered users
    modifier onlyRegisteredUsers() {
        require(users[msg.sender].isRegistered, "You are not a registered user");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    // Function to register a new user
    function registerUser(
        string memory _userID,
        string memory _fullName,
        uint256 _dateOfBirth,
        string memory _gender,
        string memory _userType,
        string memory _orgAddress,
        string memory _instituteRole,
        string memory _KYCstatus,
        string memory _userStatus,
        string memory _addressLine,
        string memory _phoneNumber,
        string memory _email,
        string memory _country,
        string memory _nationality,
        string memory _nid,
        string memory _maritalStatus,
        string memory _educationLevel,
        string memory _incomeLevel,
        string memory _employmentStatus,
        string memory _taxStatus,
        string memory _communicationPref,
        bool _consentPermission
    ) external {
        require(!users[msg.sender].isRegistered, "User is already registered");
        require(bytes(_fullName).length > 0, "Full name must not be empty");
        require(_dateOfBirth > 0, "Invalid date of birth");
        require(bytes(_email).length > 0, "Email must not be empty");

        User memory newUser = User({
            userAddress: msg.sender,
            userID: _userID,
            fullName: _fullName,
            dateOfBirth: _dateOfBirth,
            gender: _gender,
            userType: _userType,
            orgAddress: _orgAddress,
            instituteRole: _instituteRole,
            KYCstatus: _KYCstatus,
            userStatus: _userStatus,
            addressLine: _addressLine,
            phoneNumber: _phoneNumber,
            email: _email,
            country: _country,
            nationality: _nationality,
            nid: _nid,
            maritalStatus: _maritalStatus,
            educationLevel: _educationLevel,
            incomeLevel: _incomeLevel,
            employmentStatus: _employmentStatus,
            taxStatus: _taxStatus,
            communicationPref: _communicationPref,
            consentPermission: _consentPermission,
            isRegistered: true
        });

        users[msg.sender] = newUser;
        emit UserRegistered(msg.sender, _userID, _fullName, _email);
    }

    // Rest of the contract remains unchanged.
        // Function to update user information
    function updateUser(string memory _name, string memory _email) external onlyRegisteredUsers {
        require(bytes(_name).length > 0, "Name must not be empty");
        require(bytes(_email).length > 0, "Email must not be empty");

        User storage user = users[msg.sender];
        user.fullName = _name;
        user.email = _email;
    }

    // Function to unregister a user
    function unregisterUser() external onlyRegisteredUsers {
        delete users[msg.sender];
    }

    // Function to check if a user is registered
    function isUserRegistered(address _userAddress) external view returns (bool) {
        return users[_userAddress].isRegistered;
    }

    // Function to get user information
    function getUserInfo(address _userAddress) external view returns (string memory, string memory) {
        require(users[_userAddress].isRegistered, "User is not registered");
        return (users[_userAddress].fullName, users[_userAddress].email);
    }

    // Function to transfer the contract ownership to a new admin (only current admin can call this)
    function transferAdmin(address _newAdmin) external onlyAdmin {
        require(_newAdmin != address(0), "Invalid address");
        admin = _newAdmin;
    }

}
