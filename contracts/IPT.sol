// @author: Ankit Buti <ankit@startuped.net>   
// @date: September 10, 2023  

// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

// IPT ERC-20 Token for Incubation Platform
contract IPT is ERC20 {
    // Token details
    string public constant name = "Idea Property Token"; // "Incubation Platform Token"
    string public constant symbol = "IPT";
    uint8 public constant decimals = 18;
    uint256 public totalSupply;

    // Balances and allowances
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // Event to log minting of tokens
    event Minted(address indexed to, uint256 amount);
    // Event to log burning of tokens
    event Burned(address indexed from, uint256 amount);

    event TransactionEvent(address indexed from, address indexed to, uint256 value, bytes data);


    // Constructor to initialize supply
    constructor(uint256 _initialSupply) ERC20("IPT Token", "IPT") {
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;  // Allocate all initial tokens to contract deployer
        _mint(msg.sender, initialSupply);
    }

    // Approve tokens for a spender
    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    // Transfer tokens from sender to another address
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= _value, "Insufficient balance");
        
        // Safely update state
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        emit TransactionEvent(msg.sender, _to, _value, "Transfer executed");
        return true;
    }

    // Transfer tokens on behalf of someone (requires approval first)
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_to != address(0), "Invalid address");
        require(balanceOf[_from] >= _value, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");

        // Safely update state
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    /**
     * @dev Mint new tokens and send them to the given address
     * @param to The address to receive the new tokens
     * @param amount The amount of new tokens to mint
     */
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
        emit Minted(to, amount);
    }

    /**
     * @dev Burn tokens from the sender's address
     * @param amount The amount of tokens to burn
     */
    function burn(uint256 amount) external {
        _burn(msg.sender, amount);
        emit Burned(msg.sender, amount);
    }

    /**
     * @dev Add any other advanced functionalities like pausing contract, blacklisting etc
     */
    
}
