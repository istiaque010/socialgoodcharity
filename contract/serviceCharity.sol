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
        address[] implementAreas;
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

    }

    // Structure used to return metadata of each project
    struct ProjectMetadata {
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

        //from here I added extra variables for service charity
        string serviceName;
        string serviceProviderName;
        address serviceProviderAddress;
        string profession;
        string relatedEducation;
        string experience;
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
        uint256 _trusteeThreshold, // Minimum trustee approvals required

          //from here I added extra variables for service charity
        string memory _serviceName,
        string memory _serviceProviderName,
        address _serviceProviderAddress,
        string memory _profession,
        string memory _relatedEducation,
        string memory _experience


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
                experience: _experience

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

        // Check if the approval threshold is met
        if (projects[_index].trusteeApprovalCount >= projects[_index].trusteeThreshold) {
            projects[_index].isApproved = true;
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
                projects[i].experience
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
                    projects[i].category,
                    //from here I added extra variables for service charity
                    projects[i].serviceName,
                    projects[i].serviceProviderName,
                    projects[i].serviceProviderAddress,
                    projects[i].profession,
                    projects[i].relatedEducation,
                    projects[i].experience
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
                    Category.invalid_category,
                    //from here I added extra variables for service charity
                    "Invalid Project",
                    "Invalid Project",
                     address(0),
                    "Invalid Project",
                    "Invalid Project",
                    "Invalid Project"

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
