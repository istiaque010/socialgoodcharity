# Social Good Charity

## Synopsis

The charity impacts society significantly in areas including education, healthcare, hunger, drink-ing water, disaster relief, environmental preservation, and assistance for underserved people. The existing charity has numerous limitations, such as poor management, high operation costs, and lack of transparency in the donation execution flow. Authentication of users and institutions is a big problem of the existing system regarding actual appearance. In this research work, blockchain technology resolves the issue of transparency and reliability with the facility of an immutable and traceable distributed ledger for the transactions of charity funds. We have the originality to empower the existing centralized traditional charity works by blockchain tech-nology with the authentication approach, Know Your Customer (KYC), and cryptographic HASH. This proposed approach satisfies all the functionalities of the existing traditional charity framework. Personal information privacy is implemented using the filters at smart contracts. The modified implementation of KYC to ensure authenticity and make data flow securely through the channel from end users to the platform are two significant contributions of this work. A coin toss function for data selection for passing through the channel to make it tedious to attack and random time delay between data to avoid the guess for attack. We aim for this framework to send 100% of donations to the beneficiaries and become a hyper-liquid medium to fill up the United Nations Sustainable Development Goals (SDG) funding gap. In this research, we also introduce the concept of service charity to broaden the types where people offer their services and skills as charity.

# Schema design

# Figure 1. Structure of Proposed Framework

![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/4f068267-b88b-4123-a752-50fc4dc494bc)


# Figure 2. Entities of Proposed Framework

![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/2a0cc866-f6da-47d7-926a-239fbd1be162)


# Figure 3. Operation Flow of Proposed Framework

![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/d7e44a74-60b0-4763-9c1f-a49c1999529f)


# Figure 5. Know Your Customer Approach

![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/37d16771-e6b7-473f-8e63-f64e51855333)


# User Registration smart Contract

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract userRegistration {
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

```

# KYC Verification Smart Contract

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import './userRegistration.sol';

contract KYC {
    address public owner;
    userRegistration addUserReg;

    
    enum KYCStatus { Pending, Approved, Rejected }
    
    struct KYCRequest {
        address userAddress;
        string userName;
        string identificationDocument;
        KYCStatus status;
    }
    
    mapping(address => KYCRequest) public kycRequests;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }


     modifier onlyRegisteredUser() {
        require(addUserReg.isUserRegistered(msg.sender), "Only registered user can request verification for KYC");
        _;
    }

    constructor(address _addUserReg) {
        owner = msg.sender;
        addUserReg=userRegistration(_addUserReg); //convert the address and set the address for userRegistration
    }

    function submitKYCRequest(string memory _userName, string memory _identificationDocument) external onlyRegisteredUser{
        require(kycRequests[msg.sender].userAddress == address(0), "KYC request already submitted");
        
        kycRequests[msg.sender] = KYCRequest({
            userAddress: msg.sender,
            userName: _userName,
            identificationDocument: _identificationDocument,
            status: KYCStatus.Pending
        });
    }
    
    function approveKYC(address _userAddress) external onlyOwner {
        kycRequests[_userAddress].status = KYCStatus.Approved;
    }
    
    function rejectKYC(address _userAddress) external onlyOwner {
        kycRequests[_userAddress].status = KYCStatus.Rejected;
    }
    
    function getKYCStatus(address _userAddress) external view returns (KYCStatus) {
        return kycRequests[_userAddress].status;
    }

    function isKYCapproved(address _userAddress) external view returns (bool) {

        KYCStatus currentKYCstatus= kycRequests[_userAddress].status;
        if(currentKYCstatus==KYCStatus.Approved)
           return  true;
        else 
           return false;
    }
}

```

# Institution Registration smart Contrac

```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CharityPlatform {
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

```

# Charity Project Registration Smart Contract

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import './KYC.sol';

contract createCharityPro{
    address public owner;
    KYC KYCaddress;

    enum Category{
        Humanitarian_Aid,
        Education_and_Literacy,
        Healthcare_and_Medical_Research,
        Poverty_Alleviation,
        Hunger_Relief,
        Natuaral_disaster,
        Environmental_Conservation,
        Women_Empowerment,
        Children_and_Youth,
        Elderly_Care,
        Disability_Support,
        Clean_Water_and_Sanitation,
        Animal_Welfare,
        Arts_and_Culture,
        Human_Rights_and_Advocacy,
        Technology_and_Innovation,
        invalid_category
    }

    enum RefundPolicy{
        REFUNDABLE,
        NONREFUNDABLE
    }

    // Structure of each project in our dApp 
    struct Project{
        string projectName;
        string projectDescription;
        string creatorName;
        string projectLink;
        uint256 fundingGoal;
        uint256 duration;
        uint256 creationTime;
        uint256 amountRaised;
        address creatorAddress;
        Category category;
        RefundPolicy refundPolicy;
        address[] contributors;
        address[] trustees;
        address[] volunteers;
        address[] beneficiaries;
        address[] implementAreas;
        uint256[] amount;
        bool[] refundClaimed;
        bool claimedAmount;
        bool isApproved;
    }

    // Structure used to return metadata of each project
    struct ProjectMetadata{
        string projectName;
        string projectDescription;
        string creatorName;
        uint256 fundingGoal;
        uint256 amountRaised;
        uint256 totalContributors;
        uint256 creationTime;
        uint256 duration;
        bool isApproved;
        Category category;
    }

    // Each user funding gets recorded in Funded structure
    struct Funded{
		uint256 projectIndex;
		uint256 totalAmount;
    }

    // Stores all the projects 
    Project[] projects;

    // Stores the indexes of projects created on projects list by an address
    mapping(address => uint256[]) addressProjectsList;

    // Stores the list of fundings  by an address
    mapping(address => Funded[]) addressFundingList;


    // Add this modifier to restrict access to the contract owner
    modifier onlyOwner() {
    require(msg.sender == owner, "Only the contract owner can perform this action");
      _;
    }

    // Checks if an index is a valid index in projects array
    modifier validIndex(uint256 _index) {
        require(_index < projects.length, "Invalid Project Id");
        _;
    }

     modifier onlyVerifiedKYC() {
        require(KYCaddress.isKYCapproved(msg.sender), "Only verified KYC can create");
        _;
    }


  constructor(address _KYCaddress) {
        owner = msg.sender;
        KYCaddress=KYC(_KYCaddress); //convert the address and set the address for KYC
    }


    // Create a new project and updates the addressProjectsList and projects array
    function createNewProject(
         string memory _name,
         string memory _desc,
         string memory _creatorName,
         string memory _projectLink,
         uint256 _fundingGoal,
         uint256 _duration,
         Category _category,
         RefundPolicy _refundPolicy,
         address[] memory _trustees,
         address[] memory _volunteers,
         address[] memory _implementAreas
        ) external onlyVerifiedKYC {
            projects.push(Project({
            creatorAddress: msg.sender,
            projectName: _name,
            projectDescription: _desc,
            creatorName: _creatorName,
            projectLink: _projectLink,
            fundingGoal: _fundingGoal * 10**18,
            duration: _duration * (1 minutes),
            creationTime: block.timestamp,
            category: _category,
            refundPolicy: _refundPolicy,
            amountRaised: 0,
            contributors: new address[](0),
            trustees: _trustees,        // Add trustees
            volunteers: _volunteers,    // Add volunteers
            beneficiaries: new address[](0), // Initialize beneficiaries as an empty array
            implementAreas: _implementAreas, // Add implementAreas
            amount: new uint256[](0),
            claimedAmount: false,
            isApproved: false,
            refundClaimed: new bool[](0)
            }));
            addressProjectsList[msg.sender].push(projects.length - 1);  // Store the project IDs in the corresponding address
    }


     // This function to approve a charity project
    function approveProject(uint256 _index) external onlyOwner validIndex(_index) {
        require(!projects[_index].isApproved, "Project is already approved");
        require(_index < projects.length, "Invalid Project Index"); // Check if the project index is valid

        // Perform any additional checks or actions you want when approving a project

         projects[_index].isApproved = true;
    }


    // Returns the project metadata of all entries in projects
    function getAllProjectsDetail() external view returns(ProjectMetadata[] memory allProjects) {
        ProjectMetadata[] memory newList = new ProjectMetadata[](projects.length);
        for(uint256 i = 0; i < projects.length; i++){
            newList[i] = ProjectMetadata(
                projects[i].projectName,
                projects[i].projectDescription,
                projects[i].creatorName,
                projects[i].fundingGoal,
                projects[i].amountRaised,
                projects[i].contributors.length,
                projects[i].creationTime,
                projects[i].duration,
                projects[i].isApproved,
                projects[i].category
            );
        }
        return newList;
    }

    // Takes array of indexes as parameter
    // Returns array of metadata of project at respective indexes 
    function getProjectsDetail(uint256[] memory _indexList) external view returns(ProjectMetadata[] memory projectsList) {
        ProjectMetadata[] memory newList = new ProjectMetadata[](_indexList.length);
        for(uint256 index = 0; index < _indexList.length; index++) {
            if(_indexList[index] < projects.length) { 
                uint256 i = _indexList[index]; 
                newList[index] = ProjectMetadata(
                    projects[i].projectName,
                    projects[i].projectDescription,
                    projects[i].creatorName,
                    projects[i].fundingGoal,
                    projects[i].amountRaised,
                    projects[i].contributors.length,
                    projects[i].creationTime,
                    projects[i].duration,
                    projects[i].isApproved,
                    projects[i].category
                );
            } else {
                newList[index] = ProjectMetadata(
                    "Invalid Project",
                    "Invalid Project",
                    "Invalid Project",
                    0,
                    0,
                    0,
                    0,
                    0,
                    false,
                    Category.invalid_category
                );
            }

        }
        return newList;
    }

    // Returns the project at the given index
    function getProject(uint256 _index) external view validIndex(_index) returns(Project memory project) {
        return projects[_index];
    }

    // Returns array of indexes of projects created by creator
    function getCreatorProjects(address creator) external view returns(uint256[] memory createdProjects) {
        return addressProjectsList[creator];
    }

    // Returns array of details of fundings by the contributor
    function getUserFundings(address contributor) external view returns(Funded[] memory fundedProjects) {
        return addressFundingList[contributor];
    }

    // Helper function adds details of Funding to addressFundingList
    function addToFundingList(uint256 _index) internal validIndex(_index) {
        for(uint256 i = 0; i < addressFundingList[msg.sender].length; i++) {
            if(addressFundingList[msg.sender][i].projectIndex == _index) {
                addressFundingList[msg.sender][i].totalAmount += msg.value;
                return;
            }
        }
        addressFundingList[msg.sender].push(Funded(_index, msg.value));
    }

    // Helper fundtion adds details of funding to the project in projects array
    function addContribution(uint256 _index) internal validIndex(_index)  {
        for(uint256 i = 0; i < projects[_index].contributors.length; i++) {
            if(projects[_index].contributors[i] == msg.sender) {
                projects[_index].amount[i] += msg.value;
                addToFundingList(_index);
                return;
            }
        }
        projects[_index].contributors.push(msg.sender);
        projects[_index].amount.push(msg.value);
        if(projects[_index].refundPolicy == RefundPolicy.REFUNDABLE) {
            projects[_index].refundClaimed.push(false);
        }
        addToFundingList(_index);
    }

    // Funds the projects at given index
    function fundProject(uint256 _index) payable external validIndex(_index)  {
        require(projects[_index].creatorAddress != msg.sender, "You are the project owner");
        require(projects[_index].isApproved ==true, "Thsi project is not approved");
        require(projects[_index].duration + projects[_index].creationTime >= block.timestamp, "Project Funding Time Expired");
        addContribution(_index);
        projects[_index].amountRaised += msg.value;
    }

    // Helps project creator to transfer the raised funds to his address
    function claimFund(uint256 _index) validIndex(_index) external {
        require(projects[_index].creatorAddress == msg.sender, "You are not Project Owner");
        require(projects[_index].isApproved ==true, "Thsi project is not approved");
        require(projects[_index].duration + projects[_index].creationTime < block.timestamp, "Project Funding Time Not Expired");
        require(projects[_index].refundPolicy == RefundPolicy.NONREFUNDABLE 
                    || projects[_index].amountRaised >= projects[_index].fundingGoal, "Funding goal not reached");
        require(!projects[_index].claimedAmount, "Already claimed raised funds");
        projects[_index].claimedAmount = true;
        payable(msg.sender).transfer(projects[_index].amountRaised);
    }

    // Helper function to get the contributor index in the projects' contributor's array
    function getContributorIndex(uint256 _index) validIndex(_index) internal view returns(int256) {
        int256 contributorIndex = -1;
        for(uint256 i = 0; i < projects[_index].contributors.length; i++) {
            if(msg.sender == projects[_index].contributors[i]) {
                contributorIndex = int256(i);
                break;
            }
        }
        return contributorIndex;
    }

    // Enables the contributors to claim refund when refundable project doesn't reach its goal
    function claimRefund(uint256 _index) validIndex(_index) external {
        require(projects[_index].duration + projects[_index].creationTime < block.timestamp, "Project Funding Time Not Expired");
        require(projects[_index].refundPolicy == RefundPolicy.REFUNDABLE 
                    && projects[_index].amountRaised < projects[_index].fundingGoal, "Funding goal not reached");
        
        int256 index = getContributorIndex(_index);
        require(index != -1, "You did not contribute to this project");
        
        uint256 contributorIndex = uint256(index);
        require(!projects[_index].refundClaimed[contributorIndex], "Already claimed refund amount");
        
        projects[_index].refundClaimed[contributorIndex] = true;
        payable(msg.sender).transfer(projects[_index].amount[contributorIndex]);
    }

    // Function to distribute funds to a single beneficiary and add them to the beneficiaries array
    function distributeFundsToBeneficiary(uint256 _index, address _beneficiary) external payable validIndex(_index) {
        require(msg.sender == projects[_index].creatorAddress, "Only the project creator can distribute funds");
        require(projects[_index].isApproved ==true, "Thsi project is not approved");
        require(_beneficiary != address(0), "Invalid beneficiary address");

        // Transfer funds to the single beneficiary
        payable(_beneficiary).transfer(msg.value);

        // Add the beneficiary to the project's beneficiaries array
        projects[_index].beneficiaries.push(_beneficiary);
    }


}

```

# JavaScript for HASH, Random Time and Selection
```javascript
const crypto = require('crypto');


//for input value for KYC varification

function hashInput(name, nationalId) {
  try {
    const textToHash = name + nationalId;
    const hash = crypto.createHash('sha256');
    hash.update(textToHash);
    return hash.digest('hex');
  } catch (error) {
    console.error("Error:", error);
    return null; // You can choose to handle the error as needed
  }
}

// Example usage: check the HASH value
const name = "Istiaque Ahmed";
const nationalId = "1234567890";
const hashedValue = hashInput(name, nationalId);

if (hashedValue !== null) {
  console.log("Hashed value:", hashedValue);
}

//random function to pass the value into the KYC module

function randomDelay(callback) {
    // Generate a random delay between 1 and 5 seconds (you can adjust this range)
    const delayMilliseconds = Math.floor(Math.random() * 4000) + 1000;
  
    // Record the start time
    const startTime = Date.now();
  
    // Use setTimeout to introduce the delay
    setTimeout(() => {
      // Calculate the end time
      const endTime = Date.now();
      
      // Calculate the actual delay
      const actualDelay = endTime - startTime;
  
      callback(actualDelay); // Execute the callback function with the actual delay
    }, delayMilliseconds);
  }
  

//Pass the HASH vakue and input value for KYC varification using random delay

randomDelay((actualDelay) => {
    const hashedValueOut = hashInput(name, nationalId);
    if (hashedValueOut !== null) {
      console.log("Actual Delay (milliseconds):", actualDelay);
      console.log("Hashed value after delay:", hashedValueOut);
      
    if(hashedValue==hashedValueOut)
    {
        console.log("Both Hash are same no attack");
        // Pass the hashed value to your KYC module here
    }
    else
    {
        console.log("Hash mitchmatched discard the input");
    }

    }
  });

```
### Output:

![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/ee18b7ab-16fd-417b-8de7-90f0186c5796)


# Social Good Charity


# Social Good Charity


# Social Good Charity


# Social Good Charity


# Social Good Charity


# Social Good Charity


# Social Good Charity


# Social Good Charity


# Social Good Charity

