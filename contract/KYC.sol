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