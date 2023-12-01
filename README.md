# Social Good Charity

## Synopsis

This GitHub repository is to support our research paper in the area of decentralized charity. We implemented ekyc and service charity concepts in this research paper. The paper has been submitted. As soon as it will be published the detail synopsis as per the abstract of that paper. If it is published now, then the plagiarism issue will arise from the GitHub source. For more information, we request that you contact us about the research.

# Schema design

![ecdd9e70-e9f1-4e6e-9d02-e53f771e9335_page-0001](https://github.com/istiaque010/socialgoodcharity/assets/7622349/dd6bbcb5-fdf0-41d9-9ba2-acb4a40ace06)






# Figure 1. Structure of Proposed Framework

![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/4f068267-b88b-4123-a752-50fc4dc494bc)


# Figure 2. Entities of Proposed Framework

![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/2a0cc866-f6da-47d7-926a-239fbd1be162)


# Figure 3. Operation Flow of Proposed Framework

![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/d7e44a74-60b0-4763-9c1f-a49c1999529f)


# Figure 5. Know Your Customer Approach

![Picture1](https://github.com/istiaque010/socialgoodcharity/assets/7622349/94566f2f-3292-44b6-8490-4339caee49a7)



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
### Smart Contract Deployed View:

![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/7e6f0d2c-1beb-45a1-9731-a7e419231f68)

### Simulation in Remix IDE and Remix Virtual Machine Blockchain:
Deployed smart contract and transaction:
![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/64bc652c-54e2-4f39-b4d5-275310062f0e)

Successfully calling the userRegister function and transaction:
![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/1105ba66-7a48-4092-8dff-49f8ef97aa6a)
![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/806cd27d-12e6-48af-8fc5-b60fc2cfef52)


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
        string id;
        string phoneNum;
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

    function submitKYCRequest(string memory _userName, string memory _id, string memory _phoneNum, string memory _identificationDocument) external onlyRegisteredUser{
        require(kycRequests[msg.sender].userAddress == address(0), "KYC request already submitted");
        
        kycRequests[msg.sender] = KYCRequest({
            userAddress: msg.sender,
            userName: _userName,
            id:_id,
            phoneNum:_phoneNum,
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
### Smart Contract Deployed View:
![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/9fc1ab76-3f4d-4869-bcf5-2ed465de2364)

### Simulation in Remix IDE and Remix Virtual Machine Blockchain:
Deployed smart contract and transaction:
![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/eff24aed-cd59-4d79-b840-9ce49c90e7d6)

Submit the KYC request transaction:
![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/c2c5d842-328e-480d-a2db-8690155f4c18)

Approve KYC transactions:
![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/63853d34-6405-49ba-9e9a-06da12898fbb)

Get KYC status: decoded output 1 indicates KYC approved successfully.
![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/c769fb79-4039-4091-a62a-bdd06a7d346b)



# Institution Registration smart Contract

```solidity
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

```
### Smart Contract Deployed View:
![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/332aa325-1107-4bac-976b-3b93a781e3b1)

### Simulation in Remix IDE and Remix Virtual Machine Blockchain:
Deployed smart contract and transaction:
![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/73f3bdd2-eeaa-48cd-a155-c5edb4cca067)


# Service Charity Project Registration Smart Contract

```solidity
// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import './KYC.sol';

contract serviceCharity {
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

    enum RefundPolicy {
        REFUNDABLE,
        NONREFUNDABLE
    }

    // Structure of each project in our dApp
    struct Project {
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
        string[] implementAreas;
        uint256[] amount;
        bool[] refundClaimed;
        bool claimedAmount;
        bool isApproved;
        uint256 trusteeThreshold; // Minimum number of trustee approvals required
        uint256 trusteeApprovalCount; // Count of trustee approvals received
        //from here I added extra variables for service charity
        string serviceName;
        string serviceProviderName;
        address serviceProviderAddress;
        string profession;
        string relatedEducation;
        string experience;
        uint256 approximateServiceValue;

    }

    // Structure used to return metadata of each project
    struct ProjectMetadata {
        string projectName;
        string projectDescription;
        string creatorName;
        uint256 fundingGoal;
        uint256 amountRaised;


        address[] contributors;
        address[] trustees;
        address[] volunteers;
        address[] beneficiaries;


        uint256 totalContributors;
        uint256 creationTime;
        uint256 duration;
        bool isApproved;
        Category category;

        //from here I added extra variables for service charity
        string serviceName;
        string serviceProviderName;
        address serviceProviderAddress;
        string profession;
        string relatedEducation;
        string experience;
        uint256 approximateServiceValue;
    }

    // Each user funding gets recorded in Funded structure
    struct Funded {
        uint256 projectIndex;
        uint256 totalAmount;
    }

    // Stores all the projects
    Project[] public projects;

    // Mapping to track trustee approvals for each project
    mapping(uint256 => mapping(address => bool)) public trusteeApprovals;

    // Stores the indexes of projects created on projects list by an address
    mapping(address => uint256[]) public addressProjectsList;

    // Stores the list of fundings by an address
    mapping(address => Funded[]) public addressFundingList;

    // Mapping to track social evaluation for each user
    mapping(address => uint256) public socialEvaluation;

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
        KYCaddress = KYC(_KYCaddress); //convert the address and set the address for KYC
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
        string[] memory _implementAreas,
        uint256 _trusteeThreshold, // Minimum trustee approvals required

          //from here I added extra variables for service charity
        string memory _serviceName,
        string memory _serviceProviderName,
        address _serviceProviderAddress,
        string memory _profession,
        string memory _relatedEducation,
        string memory _experience,
        uint256 _approximateServiceValue


    ) external onlyVerifiedKYC {
        projects.push(
            Project({
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
                trustees: _trustees, // Add trustees
                volunteers: _volunteers, // Add volunteers
                beneficiaries: new address[](0), // Initialize beneficiaries as an empty array
                implementAreas: _implementAreas, // Add implementAreas
                amount: new uint256[](0),
                claimedAmount: false,
                isApproved: false,
                refundClaimed: new bool[](0),
                trusteeThreshold: _trusteeThreshold, // Set trustee threshold
                trusteeApprovalCount: 0 ,// Initialize trustee approval count

                 //from here I added extra variables for service charity
                serviceName: _serviceName,
                serviceProviderName:_serviceProviderName,
                serviceProviderAddress:_serviceProviderAddress,
                profession:_profession,
                relatedEducation:_relatedEducation,
                experience: _experience,
                approximateServiceValue:_approximateServiceValue

            })
        );
        addressProjectsList[msg.sender].push(projects.length - 1); // Store the project IDs in the corresponding address
    }

    // This function to approve a charity project
    function approveProject(uint256 _index) external onlyOwner validIndex(_index) {
        require(!projects[_index].isApproved, "Project is already approved");
        require(_index < projects.length, "Invalid Project Index"); // Check if the project index is valid

        // Ensure the caller is either the contract owner or a trustee of the project
        require( msg.sender == owner || isTrusteeOfProject(_index, msg.sender), "Only trustees and owner can approve"
        );

        // Check if the trustee has not already approved this project
        require( !trusteeApprovals[_index][msg.sender], "Trustee has already approved this project");

        // Mark the trustee's approval
        trusteeApprovals[_index][msg.sender] = true;
        projects[_index].trusteeApprovalCount++;
        socialEvaluation[msg.sender] += 1;  // Increase social evaluation for the project trustee upon approval of that project

        // Check if the approval threshold is met
        if (projects[_index].trusteeApprovalCount >= projects[_index].trusteeThreshold) {
            projects[_index].isApproved = true;
            // Increase social evaluation for the project creator upon approval of that project
            address creator = projects[_index].creatorAddress;
            socialEvaluation[creator] += 1;

            // Increase social evaluation for the project service provider upon approval of that project
            address serviceProvider = projects[_index].serviceProviderAddress;
            socialEvaluation[serviceProvider] += 1;
        }
    }


    // Helper function to check if an address is a trustee of a project
    function isTrusteeOfProject(uint256 _index, address _address)
        internal
        view
        returns (bool)
    {
        for (uint256 i = 0; i < projects[_index].trustees.length; i++) {
            if (projects[_index].trustees[i] == _address) {
                return true;
            }
        }
        return false;
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

                projects[i].contributors,
                projects[i].trustees,
                projects[i].volunteers,
                projects[i].beneficiaries,

                projects[i].contributors.length,
                projects[i].creationTime,
                projects[i].duration,
                projects[i].isApproved,
                projects[i].category,

                //from here I added extra variables for service charity
                projects[i].serviceName,
                projects[i].serviceProviderName,
                projects[i].serviceProviderAddress,
                projects[i].profession,
                projects[i].relatedEducation,
                projects[i].experience,
                projects[i].approximateServiceValue

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

                    projects[i].contributors,
                    projects[i].trustees,
                    projects[i].volunteers,
                    projects[i].beneficiaries,

                    projects[i].contributors.length,
                    projects[i].creationTime,
                    projects[i].duration,
                    projects[i].isApproved,
                    projects[i].category,
                    //from here I added extra variables for service charity
                    projects[i].serviceName,
                    projects[i].serviceProviderName,
                    projects[i].serviceProviderAddress,
                    projects[i].profession,
                    projects[i].relatedEducation,
                    projects[i].experience,
                    projects[i].approximateServiceValue
                );
            } else {
                newList[index] = ProjectMetadata(
                    "Invalid Project",
                    "Invalid Project",
                    "Invalid Project",
                    0,
                    0,

                    new address[](0),
                    new address[](0),
                    new address[](0),
                    new address[](0),

                    0,
                    0,
                    0,
                    false,
                    Category.invalid_category,
                    //from here I added extra variables for service charity
                    "Invalid Project",
                    "Invalid Project",
                     address(0),
                    "Invalid Project",
                    "Invalid Project",
                    "Invalid Project",
                    0

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
        socialEvaluation[msg.sender] += 1;
        }
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


     // Function to get the social evaluation score for a specific address
    function getSocialEvaluationForAddress(address _userAddress) external view returns (uint256) {
    return socialEvaluation[_userAddress];
    }


}
```
### Smart Contract Deployed View:
![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/f9212b6e-c5f2-4022-95d7-4c757bba6be6)


# General Charity Project Registration Smart Contract

```solidity

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import './KYC.sol';

contract createCharityPro {
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

    enum RefundPolicy {
        REFUNDABLE,
        NONREFUNDABLE
    }

    // Structure of each project in our dApp
    struct Project {
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
        string[] implementAreas;
        uint256[] amount;
        bool[] refundClaimed;
        bool claimedAmount;
        bool isApproved;
        uint256 trusteeThreshold; // Minimum number of trustee approvals required
        uint256 trusteeApprovalCount; // Count of trustee approvals received
    }

    // Structure used to return metadata of each project
    struct ProjectMetadata {
        string projectName;
        string projectDescription;
        string creatorName;
        uint256 fundingGoal;
        uint256 amountRaised;

        address[] contributors;
        address[] trustees;
        address[] volunteers;
        address[] beneficiaries;


        uint256 totalContributors;
        uint256 creationTime;
        uint256 duration;
        bool isApproved;
        Category category;
    }

    // Each user funding gets recorded in Funded structure
    struct Funded {
        uint256 projectIndex;
        uint256 totalAmount;
    }

    // Stores all the projects
    Project[] public projects;

    // Mapping to track trustee approvals for each project
    mapping(uint256 => mapping(address => bool)) public trusteeApprovals;

    // Stores the indexes of projects created on projects list by an address
    mapping(address => uint256[]) public addressProjectsList;

    // Stores the list of fundings by an address
    mapping(address => Funded[]) public addressFundingList;

    // Mapping to track social evaluation for each user
    mapping(address => uint256) public socialEvaluation;

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
        KYCaddress = KYC(_KYCaddress); //convert the address and set the address for KYC
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
        address[] memory _implementAreas,
        uint256 _trusteeThreshold // Minimum trustee approvals required
    ) external onlyVerifiedKYC {
        projects.push(
            Project({
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
                trustees: _trustees, // Add trustees
                volunteers: _volunteers, // Add volunteers
                beneficiaries: new address[](0), // Initialize beneficiaries as an empty array
                implementAreas: _implementAreas, // Add implementAreas
                amount: new uint256[](0),
                claimedAmount: false,
                isApproved: false,
                refundClaimed: new bool[](0),
                trusteeThreshold: _trusteeThreshold, // Set trustee threshold
                trusteeApprovalCount: 0 // Initialize trustee approval count
            })
        );
        addressProjectsList[msg.sender].push(projects.length - 1); // Store the project IDs in the corresponding address
    }

    // This function to approve a charity project
    function approveProject(uint256 _index) external onlyOwner validIndex(_index) {
        require(!projects[_index].isApproved, "Project is already approved");
        require(_index < projects.length, "Invalid Project Index"); // Check if the project index is valid

        // Ensure the caller is either the contract owner or a trustee of the project
        require( msg.sender == owner || isTrusteeOfProject(_index, msg.sender), "Only trustees and owner can approve"
        );

        // Check if the trustee has not already approved this project
        require( !trusteeApprovals[_index][msg.sender], "Trustee has already approved this project");

        // Mark the trustee's approval
        trusteeApprovals[_index][msg.sender] = true;
        projects[_index].trusteeApprovalCount++;
        socialEvaluation[msg.sender] += 1;  // Increase social evaluation for the project trustee upon approval of that project
        

        // Check if the approval threshold is met
        if (projects[_index].trusteeApprovalCount >= projects[_index].trusteeThreshold) {
            projects[_index].isApproved = true;

            // Increase social evaluation for the project creator upon approval of that project
            address creator = projects[_index].creatorAddress;
            socialEvaluation[creator] += 1;
        }
    }


    // Helper function to check if an address is a trustee of a project
    function isTrusteeOfProject(uint256 _index, address _address)
        internal
        view
        returns (bool)
    {
        for (uint256 i = 0; i < projects[_index].trustees.length; i++) {
            if (projects[_index].trustees[i] == _address) {
                return true;
            }
        }
        return false;
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


               projects[i].contributors,
               projects[i].trustees,
               projects[i].volunteers,
               projects[i].beneficiaries,

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

                    projects[i].contributors,
                    projects[i].trustees,
                    projects[i].volunteers,
                    projects[i].beneficiaries,


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
                    
                    new address[](0),
                    new address[](0),
                    new address[](0),
                    new address[](0),


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
         socialEvaluation[msg.sender] += 1; // Increase social evaluation for the project doner
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

    // Function to get the social evaluation score for a specific address
    function getSocialEvaluationForAddress(address _userAddress) external view returns (uint256) {
    return socialEvaluation[_userAddress];
    }


}

```

### Smart Contract Deployed View:
![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/286be8d0-5f87-42bf-92f3-132a562251c3)




# JavaScript for HASH, Random Time and Selection
```javascript
const crypto = require('crypto');
const readline = require('readline');

let name_data, nationalId_data, hashedValue_data; // Declare variables at the beginning

const rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout
});

// Function to hash input values for KYC verification
function hashInput(name, nationalId) {
  try {
    const textToHash = name + nationalId;
    const hash = crypto.createHash('sha256');
    hash.update(textToHash);
    return hash.digest('hex');
  } catch (error) {
    console.error("Error:", error.message);
    throw error; // Rethrow the error for better handling
  }
}

// Function to get user's name
function getName(callback) {
  rl.question('Enter your name: ', (name) => {
    callback(name);
  });
}

// Function to get user's national ID
function getNationalId(callback) {
  rl.question('Enter your national ID: ', (nationalId) => {
    callback(nationalId);
  });
}

// Function to perform a coin toss (returns 0 or 1 randomly)
function coinToss() {
  return Math.floor(Math.random() * 2);
}

/// Function to check hash values without random delay
function checkHashValues(name, nationalId, hashedValue) {
    
    try {
      // Calculate the hashed value without introducing a random delay
      const hashedValueOut = hashInput(name, nationalId);
      console.log("Hashed value at destination:", hashedValueOut);
  
      // Compare the original hashed value with the recalculated one
      if (hashedValue === hashedValueOut) {
        console.log("Both Hash values are the same; no attack detected.");
        // Pass the hashed value to your KYC module here
      } else {
        console.log("Hash values mismatched; discard the input.");
      }
    } catch (error) {
      console.error("Error during hash generation:", error.message);
      // Handle the error as needed
    }
  }
  

// Example usage
getName((name) => {
  getNationalId((nationalId) => {
    rl.close();

    // Example usage: check the HASH value
    const hashedValue = hashInput(name, nationalId);

    // Call the coinToss function
    const coinTossOut = coinToss();

    // Use the result (0 or 1) in a conditional statement
    if (coinTossOut === 0) {
        console.log("Hashed value:", hashedValue);
        name_data = name;
        nationalId_data = nationalId;
      // Call randomDelay before performing action A
      randomDelay((actualDelay) => {
        console.log("Coin toss result is 0. Performing action A with random delay: Passing: name, NationalId.");
        console.log("Actual Delay (milliseconds):", actualDelay);
        // Perform action A

        hashedValue_data = hashedValue;
    
        // Pass variables to checkHashValues
        checkHashValues(name_data, nationalId_data, hashedValue_data);
      });
    } else {
        console.log("Hashed value:", hashedValue);
        nationalId_data = nationalId;
      // Call randomDelay before performing action B
      randomDelay((actualDelay) => {
        console.log("Coin toss result is 1. Performing action B with random delay: Passing HASH.");
        console.log("Actual Delay (milliseconds):", actualDelay);
        // Perform action B
        hashedValue_data = hashedValue;
        name_data = name;
        // Pass variables to checkHashValues
        checkHashValues(name_data, nationalId_data, hashedValue_data);
      });
    }
  });
});

// Random function to pass the value into the KYC module
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



```
### Output:

![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/5ccbe8ef-ec9f-4db8-beaf-458290d743d1)



# Proposed UI/UX Figma Design

[Click Here for Figma UI/UX](https://www.figma.com/file/g7y6lpkuKJCX3obTEcM8kM/crazycrypto?type=design&node-id=0-1&mode=design)

![image](https://github.com/istiaque010/socialgoodcharity/assets/7622349/34ff5389-4552-41e8-99dd-7af26cec95b7)



# Prototype Test in Localhost

![Untitled](https://github.com/istiaque010/socialgoodcharity/assets/7622349/f0c3c5b5-073c-4da0-914d-00d11b062a88)



