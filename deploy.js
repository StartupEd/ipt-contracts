// @author: Ankit Buti <ankit@startuped.net>   
// @date: September 10, 2023  

// SPDX-License-Identifier: GPL-3.0-or-later

import { ethers, defender } from "hardhat";
    
async function main() {
   const Box = await ethers.getContractFactory("Box");
   const deployment = await defender.deployProxy(Box);
   await deployment.waitForDeployment();
   console.log(`Contract deployed at ${deployment.getAddress()}`);
}   
