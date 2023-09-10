// @author: Ankit Buti <ankit@startuped.net>   
// @date: September 10, 2023  

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract PublicVestingContract {
    IERC20 public iptToken;
    address public beneficiary;
    uint256 public startTime;
    uint256 public totalAmount;
    uint256 public duration;
    uint256 public claimed;

    event TokensClaimed(address beneficiary, uint256 amount);

    constructor(
        address _iptToken,
        address _beneficiary,
        uint256 _startTime,
        uint256 _totalAmount,
        uint256 _duration
    ) {
        iptToken = IERC20(_iptToken);
        beneficiary = _beneficiary;
        startTime = _startTime;
        totalAmount = _totalAmount;
        duration = _duration;
        claimed = 0;
    }

    function claim() public {
        require(msg.sender == beneficiary, "Only the beneficiary can claim tokens");
        require(block.timestamp >= startTime, "Vesting hasn't started yet");

        uint256 elapsedTime = block.timestamp - startTime;
        uint256 availableAmount = (totalAmount * elapsedTime) / duration;

        require(availableAmount > claimed, "No tokens available for claiming");

        uint256 claimAmount = availableAmount - claimed;
        claimed += claimAmount;

        require(iptToken.transfer(beneficiary, claimAmount), "Token transfer failed");

        emit TokensClaimed(beneficiary, claimAmount);
    }
}
