// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CharityPlatform {
    struct CharityProject {
        address organizationAddress;
        uint256 projectID;
        string projectName;
        address[] trusteesID;
        address[] donersID;
        address[] volunteersID;
        address[] beneficiariesID;
        string[] implementArea;
        string mission;
        string targetedBeneficiaries;
        uint256 clusterSize;
        uint256 startingDate;
        uint256 endDate;
        uint256 projectedAmount;
        uint256 collectedAmount;
        string serviceName;
        string[] relatedEducation;
        string experience;
        bool isApproved;
    }

    // Address of the contract creator (admin)
    address public admin;

    // Mapping to store charity project information by project ID
    mapping(uint256 => CharityProject) public charityProjects;

    // Counter to keep track of the next project ID
    uint256 public nextProjectID;

    // Event to notify when a new charity project is registered
    event ProjectRegistered(uint256 indexed projectID, string projectName, uint256 projectedAmount);

    // Modifier to restrict access to only the contract admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only the admin can perform this action");
        _;
    }

    constructor() {
        admin = msg.sender;
        nextProjectID = 1; // Initialize the project ID counter to 1
    }

    // Function to register a new charity project
    function registerProject(
        string memory _projectName,
        address[] memory _trusteesID,
        address[] memory _donersID,
        address[] memory _volunteersID,
        address[] memory _beneficiariesID,
        string[] memory _implementArea,
        string memory _mission,
        string memory _targetedBeneficiaries,
        uint256 _clusterSize,
        uint256 _startingDate,
        uint256 _endDate,
        uint256 _projectedAmount,
        string memory _serviceName,
        string[] memory _relatedEducation,
        string memory _experience
    ) external {
        require(bytes(_projectName).length > 0, "Project name must not be empty");
        require(_projectedAmount > 0, "Projected amount must be greater than zero");

        CharityProject memory newProject = CharityProject({
            organizationAddress: msg.sender,
            projectID: nextProjectID,
            projectName: _projectName,
            trusteesID: _trusteesID,
            donersID: _donersID,
            volunteersID: _volunteersID,
            beneficiariesID: _beneficiariesID,
            implementArea: _implementArea,
            mission: _mission,
            targetedBeneficiaries: _targetedBeneficiaries,
            clusterSize: _clusterSize,
            startingDate: _startingDate,
            endDate: _endDate,
            projectedAmount: _projectedAmount,
            collectedAmount: 0, // Initialize collected amount to zero
            serviceName: _serviceName,
            relatedEducation: _relatedEducation,
            experience: _experience,
            isApproved: false
        });

        charityProjects[nextProjectID] = newProject;
        emit ProjectRegistered(nextProjectID, _projectName, _projectedAmount);

        // Increment the project ID for the next project
        nextProjectID++;
    }

    // Function to update charity project information (only the organization that created the project can update)
    function updateProject(
        uint256 _projectID,
        string memory _projectName,
        address[] memory _trusteesID,
        address[] memory _donersID,
        address[] memory _volunteersID,
        address[] memory _beneficiariesID,
        string[] memory _implementArea,
        string memory _mission,
        string memory _targetedBeneficiaries,
        uint256 _clusterSize,
        uint256 _startingDate,
        uint256 _endDate,
        uint256 _projectedAmount,
        uint256 _collectedAmount,
        string memory _serviceName,
        string[] memory _relatedEducation,
        string memory _experience
    ) external {
        require(charityProjects[_projectID].organizationAddress == msg.sender, "You are not the owner of this project");
        require(_projectID > 0, "Invalid project ID");
        require(bytes(_projectName).length > 0, "Project name must not be empty");
        require(_projectedAmount > 0, "Projected amount must be greater than zero");

        CharityProject storage project = charityProjects[_projectID];
        project.projectName = _projectName;
        project.trusteesID = _trusteesID;
        project.donersID = _donersID;
        project.volunteersID = _volunteersID;
        project.beneficiariesID = _beneficiariesID;
        project.implementArea = _implementArea;
        project.mission = _mission;
        project.targetedBeneficiaries = _targetedBeneficiaries;
        project.clusterSize = _clusterSize;
        project.startingDate = _startingDate;
        project.endDate = _endDate;
        project.projectedAmount = _projectedAmount;
        project.collectedAmount = _collectedAmount;
        project.serviceName = _serviceName;
        project.relatedEducation = _relatedEducation;
        project.experience = _experience;
    }

    // Function to delete a charity project (only the organization that created the project can delete)
    function deleteProject(uint256 _projectID) external {
        require(charityProjects[_projectID].organizationAddress == msg.sender, "You are not the owner of this project");
        delete charityProjects[_projectID];
    }

    // Function to approve a charity project (only the contract admin can approve)
    function approveProject(uint256 _projectID) external onlyAdmin {
        require(charityProjects[_projectID].projectID != 0, "Project with this ID does not exist");
        charityProjects[_projectID].isApproved = true;
    }

    // Function to get the details of a charity project
    function getProjectDetails(uint256 _projectID)
        external
        view
        returns (
            address,
            string memory,
            address[] memory,
            address[] memory,
            address[] memory,
            address[] memory,
            string[] memory,
            string memory,
            string memory,
            uint256,
            uint256,
            uint256,
            uint256,
            uint256,
            string memory,
            string[] memory,
            string memory,
            bool
        )
    {
        CharityProject memory project = charityProjects[_projectID];
        return (
            project.organizationAddress,
            project.projectName,
            project.trusteesID,
            project.donersID,
            project.volunteersID,
            project.beneficiariesID,
            project.implementArea,
            project.mission,
            project.targetedBeneficiaries,
            project.clusterSize,
            project.startingDate,
            project.endDate,
            project.projectedAmount,
            project.collectedAmount,
            project.serviceName,
            project.relatedEducation,
            project.experience,
            project.isApproved
        );
    }
}
