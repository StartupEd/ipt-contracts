// @author: Ankit Buti <ankit@startuped.net>   
// @date: September 10, 2023  

// SPDX-License-Identifier: GPL-3.0-or-later

// hardhat-config.js
require('@openzeppelin/hardhat-upgrades');
require('dotenv').config();
  
module.exports = {
    defender: {
        apiKey: process.env.API_KEY,
        apiSecret: process.env.API_SECRET,
    }
}