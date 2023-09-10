// @author: Ankit Buti <ankit@startuped.net>   
// @date: September 10, 2023  

// SPDX-License-Identifier: GPL-3.0-or-later

const IPT = artifacts.require("IPT");
const StakingContract = artifacts.require("StakingContract");
const PublicVesting = artifacts.require("PublicVesting");
const PrivateVesting = artifacts.require("PrivateVesting");

contract('IPT and StakingContract', function(accounts) {
    it('should deploy IPT and StakingContract correctly', async function() {
        const ipt = await IPT.deployed();
        const staking = await StakingContract.deployed();
        
        // assertions here
    });

    it('should stake tokens correctly', async function() {
        const ipt = await IPT.deployed();
        const staking = await StakingContract.deployed();

        await ipt.approve(staking.address, 100, {from: accounts[0]});
        await staking.stakeTokens(100, {from: accounts[0]});

        // assertions here
    });

    // Add more test cases...
});

contract("IPTToken", accounts => {
    let iptTokenInstance;
  
    before(async () => {
      iptTokenInstance = await IPTToken.deployed();
    });
  
    // Test if IPT Token is deployed successfully
    it("should deploy IPT token", async () => {
      assert(iptTokenInstance !== undefined, "IPTToken contract should be defined");
    });
  });
  
  contract("PublicVesting", accounts => {
    let publicVestingInstance;
  
    before(async () => {
      publicVestingInstance = await PublicVesting.deployed();
    });
  
    // Test if PublicVesting is deployed successfully
    it("should deploy PublicVesting contract", async () => {
      assert(publicVestingInstance !== undefined, "PublicVesting contract should be defined");
    });
  
    // Add more tests specific to PublicVesting here
  });
  
  contract("PrivateVesting", accounts => {
    let privateVestingInstance;
  
    before(async () => {
      privateVestingInstance = await PrivateVesting.deployed();
    });
  
    // Test if PrivateVesting is deployed successfully
    it("should deploy PrivateVesting contract", async () => {
      assert(privateVestingInstance !== undefined, "PrivateVesting contract should be defined");
    });
  
    // Add more tests specific to PrivateVesting here
  });
  
  // Add other tests to check for behaviors, conditions, state changes, etc.



/*
Instructions

This is a very basic test file and should be extended to cover all aspects of your smart contracts, such as:
 - Minting and burning tokens
 - Transferring tokens
 - Vesting and releasing tokens
 - Any edge cases or conditions specific to your contracts

To run your tests, use the command truffle test in your project directory. Make sure to write additional tests to cover all the functionalities of your contracts.
*/