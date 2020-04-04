require('babel-register');
require('babel-polyfill');
const HDWalletProvider = require("truffle-hdwallet-provider");

const mnemonic = 'despair arrive logic galaxy bottom field rabbit absurd snow proud dwarf blood';

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 8545,
      network_id: "*" // Match any network id
    },
    ropsten: {
      provider: () => new HDWalletProvider(
        mnemonic,
        "https://ropsten.infura.io/v3/4a3706ac2ddf434fbc3ca2e68a746382"
      ),
      network_id: 3,
      gas: 4700000
    },
    rinkeby: {
      provider: () => new HDWalletProvider(
        mnemonic,
        "https://rinkeby.infura.io/v3/4a3706ac2ddf434fbc3ca2e68a746382"
      ),
      network_id: 4,
      gas: 47000000
    },
    kovan: {
      provider: () => new HDWalletProvider(
        mnemonic,
        "https://kovan.infura.io/v3/4a3706ac2ddf434fbc3ca2e68a746382"
      ),
      network_id: 42,
      gas: 47000000
    },
    main: {
      provider: () => new HDWalletProvider(
        mnemonic,
        "https://mainnet.infura.io/v3/4a3706ac2ddf434fbc3ca2e68a746382",
      ),
      network_id: 5,
      gas: 4700000
    },
  },
 
  contracts_directory: './src/contracts/',
  contracts_build_directory: './src/abis/',
  compilers: {
    solc: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  }
}
