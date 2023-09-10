// @author: Ankit Buti <ankit@startuped.net>   
// @date: September 10, 2023  

// SPDX-License-Identifier: GPL-3.0-or-later


const Web3 = require("web3");
const web3 = new Web3(new Web3.providers.WebsocketProvider("wss://rinkeby.infura.io/ws"));

const iptContract = new web3.eth.Contract(Your_ABI, Your_Contract_Address);

iptContract.events.TransactionEvent({
    fromBlock: 'latest'
}, function (error, event) {
    if (error) {
        console.error(error);
        return;
    }
    // Extract event parameters
    const { from, to, value, data } = event.returnValues;
    // Call StartupEd middleware API
    callStartupEdAPI(from, to, value, data);
})
.on('error', console.error);

function callStartupEdAPI(from, to, value, data) {
    // Implement your API call here
    // For example, using Axios to perform the API request
    const axios = require('axios');

    axios.post('https://api.startuped.net/transaction', {
        from,
        to,
        value,
        data
    })
    .then(response => {
        console.log("Successfully called StartupEd middleware", response.data);
    })
    .catch(error => {
        console.log("Error calling StartupEd middleware", error);
    });
}
