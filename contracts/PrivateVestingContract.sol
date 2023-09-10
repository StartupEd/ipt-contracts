// @author: Ankit Buti <ankit@startuped.net>   
// @date: September 10, 2023  

// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.0;

import "./IPT.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PrivateVestingContract {
    IPT public iptToken; // The IPT token
    address public beneficiary; // Beneficiary of vested tokens
    uint256 public cliff; // Time before vesting starts
    uint256 public start; // Start time
    uint256 public duration; // Duration of vesting

    uint256 public released = 0; // Tokens already released

    event TokensClaimed(address beneficiary, uint256 amount);

    constructor(
        address _iptTokenAddress,
        address _beneficiary,
        uint256 _start,
        uint256 _cliff,
        uint256 _duration
    ) {
        iptToken = IPT(_iptTokenAddress);
        beneficiary = _beneficiary;
        start = _start;
        cliff = _start + _cliff;
        duration = _duration;
    }

     function addBeneficiary(address _beneficiary, uint256 _amount) external onlyOwner {
        amounts[_beneficiary] = _amount;
    }

    function claim() public {
        require(block.timestamp >= startTime, "Vesting hasn't started yet");
        require(amounts[msg.sender] > 0, "You have no tokens to claim");

        uint256 claimAmount = amounts[msg.sender];
        amounts[msg.sender] = 0;

        require(iptToken.transfer(msg.sender, claimAmount), "Token transfer failed");

        emit TokensClaimed(msg.sender, claimAmount);
    }

    function release() public {
        uint256 unreleased = releasableAmount();
        require(unreleased > 0, "No tokens to release");

        released += unreleased;
        iptToken.transfer(beneficiary, unreleased);
    }

    function releasableAmount() public view returns (uint256) {
        return vestedAmount() - released;
    }

    function vestedAmount() public view returns (uint256) {
        uint256 currentBalance = iptToken.balanceOf(address(this));
        uint256 totalBalance = currentBalance + released;

        if (block.timestamp < cliff) {
            return 0;
        } else if (block.timestamp >= start + duration) {
            return totalBalance;
        } else {
            return (totalBalance * (block.timestamp - start)) / duration;
        }
    }
}
