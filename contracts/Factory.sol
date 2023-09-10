// @author: Ankit Buti <ankit@startuped.net>   
// @date: September 10, 2023  

// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.0; 

import "./IPTInterface.sol";

/* This factory contract allows you to deploy new IPT contracts and keeps track of all deployed contracts in an array. 
You can extend it to add administrative controls, versioning, or other features as needed. */

contract IPTFactory {

    address public owner;
    address public latestIPT;
    address[] public deployedIPTContracts;
    mapping(address => uint) public versionOf;

    event IPTCreated(address indexed newIPTAddress, uint version);
    event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);

    constructor() {
        owner = msg.sender;  // Set the contract deployer as the initial owner
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    // Function to create a new IPT contract
    function createNewIPT() public onlyOwner {
        IPTInterface newIPT = new IPT(/* constructor arguments if any */);
        deployedIPTContracts.push(address(newIPT));
        latestIPT = address(newIPT);
        versionOf[address(newIPT)] = deployedIPTContracts.length;

        emit IPTCreated(address(newIPT), deployedIPTContracts.length);
    }

    // Function to get all deployed IPT contracts
    function getDeployedIPTContracts() public view returns(address[] memory) {
        return deployedIPTContracts;
    }

    // Function to transfer ownership to a new address
    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner address cannot be 0x0");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    // Function to get the version of a particular IPT contract
    function getVersionOf(address iptContract) public view returns(uint) {
        return versionOf[iptContract];
    }

    // Function to manually update the latest IPT, if necessary
    function setLatestIPT(address _latestIPT) public onlyOwner {
        latestIPT = _latestIPT;
    }
}


/*
Explanation of Added Features:

1. owner: A state variable to keep track of the contract's owner.
2. onlyOwner: A modifier to restrict certain function calls to the contract's owner.
3. versionOf: A mapping to keep track of each IPT contract's version.
4. OwnershipTransferred: An event to log ownership transfers.
5.transferOwnership: Function to transfer the ownership of the factory.
6. getVersionOf: Function to get the version number of a specific IPT contract.
7. setLatestIPT: Function to manually set the latest IPT contract.

*/