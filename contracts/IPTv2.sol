// @author: Ankit Buti <ankit@startuped.net>   
// @date: September 10, 2023  

// SPDX-License-Identifier: GPL-3.0-or-later

/* TODO IMP - Figure out a way to update the contract on chain. */

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract IdeaPropertyToken is ERC20, Ownable, Pausable {
    mapping (address => uint256) private _stakes;
    mapping (address => uint256) private _rewards;
    mapping (address => bool) private _stakers;

    event Staked(address indexed user, uint256 amount, uint256 total);
    event Unstaked(address indexed user, uint256 amount, uint256 total);
    event RewardPaid(address indexed user, uint256 reward);

    constructor() ERC20("Idea Property Token", "IPT") {
        _mint(msg.sender, 1000000000 * 10 ** decimals()); // mint 1 billion IPT tokens to contract creator
    }

    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public onlyOwner {
        _burn(from, amount);
    }

    function stake(uint256 amount) public whenNotPaused {
        _burn(msg.sender, amount);
        _stakes[msg.sender] += amount;
        _stakers[msg.sender] = true;
        emit Staked(msg.sender, amount, _stakes[msg.sender]);
    }

    function unstake(uint256 amount) public whenNotPaused {
        require(_stakes[msg.sender] >= amount, "Not enough tokens staked");
        _stakes[msg.sender] -= amount;
        _mint(msg.sender, amount);
        emit Unstaked(msg.sender, amount, _stakes[msg.sender]);
    }

    function reward(address user, uint256 amount) public onlyOwner {
        _rewards[user] += amount;
        emit RewardPaid(user, amount);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function isStaker(address account) public view returns (bool) {
        return _stakers[account];
    }

    function stakeOf(address account) public view returns (uint256) {
        return _stakes[account];
    }

    function rewardOf(address account) public view returns (uint256) {
        return _rewards[account];
    }
}
