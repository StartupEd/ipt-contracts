// @author: Ankit Buti <ankit@startuped.net>   
// @date: September 10, 2023  

// SPDX-License-Identifier: GPL-3.0-or-later

const Web3 = require('web3');
const { abi } = require('./IPTContract.json'); // Replace with the actual ABI

// Connect to the Ethereum blockchain
const web3 = new Web3('wss://polygon-matic.network'); // Replace with the actual RPC URL

// The address of the IPT smart contract
const contractAddress = '0xYourContractAddress';

// Initialize a contract object
const iptContract = new web3.eth.Contract(abi, contractAddress);

// Table to keep track of wallet holdings and transactions
let walletTable = {};

// Event Listener for Transfer Events
iptContract.events.Transfer({
    filter: {},
    fromBlock: 0,
    toBlock: 'latest',
})
.on('data', function(event){
    let { from, to, value } = event.returnValues;

    // Update walletTable
    walletTable[from] = (walletTable[from] || 0) - value;
    walletTable[to] = (walletTable[to] || 0) + value;

    // Add Transaction Record
    console.log(`Transaction: ${from} transferred ${value} IPT to ${to}`);
    console.log('Updated Wallet Table:', walletTable);
})
.on('error', console.error);

// You can set up additional logic to periodically save `walletTable`
// to a database or other persistent storage.


/*
This listener will start tracking IPT transfers from block 0 to the latest. It will keep an in-memory JavaScript object (walletTable) updated with the amount of IPT held in each address.

Note:

Replace './IPTContract.json' with the actual path to your ABI JSON file.
Replace '0xYourContractAddress' with your contract's actual address.
Replace the RPC URL with the actual one you're using.
Finally, for production use, you would likely want to store the walletTable in a more permanent form of storage, like a database, instead of an in-memory object.
*/