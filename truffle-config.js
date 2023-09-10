// @author: Ankit Buti <ankit@startuped.net>   
// @date: September 10, 2023  

// SPDX-License-Identifier: GPL-3.0-or-later

module.exports = {
    networks: {
      rinkeby: {
        provider: function() {
          return new HDWalletProvider(process.env.MNEMONIC, "https://rinkeby.infura.io/v3/" + process.env.INFURA_API_KEY)
        },
        network_id: 4
      }
    }
  };

