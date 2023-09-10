// @author: Ankit Buti <ankit@startuped.net>   
// @date: September 10, 2023  

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "./IPT.sol";

// Staking contract for IPT Token
contract StakingContract {
    // State variables
    IPT public token; // IPT token instance
    mapping(address => uint256) public stakersBalance; // Staked balance
    mapping(address => bool) public isStaking; // Staking status

    // Events
    event Stake(address indexed staker, uint256 amount);
    event Unstake(address indexed staker, uint256 amount);

    // Initialize with IPT token address
    constructor(address _tokenAddress) {
        token = IPT(_tokenAddress);
    }

    // Stake IPT tokens
    function stakeTokens(uint256 _amount) public {
        require(_amount > 0, "Amount cannot be 0");
        require(token.transferFrom(msg.sender, address(this), _amount), "Transfer failed");

        // Update staking status
        stakersBalance[msg.sender] += _amount;
        isStaking[msg.sender] = true;

        emit Stake(msg.sender, _amount);
    }

    // Unstake IPT tokens
    function unstakeTokens() public {
        uint256 balance = stakersBalance[msg.sender];
        require(balance > 0, "Staking balance cannot be 0");
        require(token.transfer(msg.sender, balance), "Transfer failed");

        // Update staking status
        stakersBalance[msg.sender] = 0;
        isStaking[msg.sender] = false;

        emit Unstake(msg.sender, balance);
    }
}
