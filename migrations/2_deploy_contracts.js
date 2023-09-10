// @author: Ankit Buti <ankit@startuped.net>   
// @date: September 10, 2023  

// SPDX-License-Identifier: GPL-3.0-or-later

const IPTToken = artifacts.require("IPTToken");
const PublicVestingContract = artifacts.require("PublicVestingContract");
const PrivateVestingContract = artifacts.require("PrivateVestingContract");

module.exports = function(deployer, network, accounts) {
  const iptTokenInitialSupply = web3.utils.toWei("1000000", "ether");
  const startTime = Math.floor(Date.now() / 1000);  // Now, in Unix time
  const totalAmount = web3.utils.toWei("500000", "ether");
  const duration = 365 * 24 * 60 * 60;  // 1 year in seconds
  
  deployer.deploy(IPTToken, iptTokenInitialSupply).then(function() {
    return deployer.deploy(
      PublicVestingContract,
      IPTToken.address,
      accounts[0],  // Replace with the actual beneficiary address
      startTime,
      totalAmount,
      duration
    );
  }).then(function() {
    return deployer.deploy(
      PrivateVestingContract,
      IPTToken.address,
      startTime,
      duration
    );
  });
};


/*
 * This migration script will first deploy the IPTToken contract, followed by the PublicVestingContract and PrivateVestingContract. The PublicVestingContract and PrivateVestingContract will be initialized with the IPTToken's address, so they can interact with the IPT token contract.
 * Remember to replace the startTime, totalAmount, and duration as per your project requirements and adjust accounts[0] to the actual beneficiary address you'd like to use.
 * After creating the migration file, you can deploy your contracts using Truffle's deploy command, specifying the Polygon Matic Network:
 */
