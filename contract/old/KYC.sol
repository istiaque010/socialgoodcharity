pragma solidity ^0.8.0;

contract KYC {
    address public owner;
    
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
    
    constructor() {
        owner = msg.sender;
    }
    
    function submitKYCRequest(string memory _userName, string memory _identificationDocument) external {
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
}