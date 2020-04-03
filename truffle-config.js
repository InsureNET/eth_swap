require('babel-register');
require('babel-polyfill');

module.exports = {
  networks: {
    development: {
      host: "127.0.0.1",
      port: 7545,
      network_id: "*" // Match any network id
    },
  },
  ropsten: {
    provider: () => new HDWalletProvider(
      mnemonic,
      "https://ropsten.infura.io/v3/e8cc7c8e245b46b482873ce9382a542b"
    ),
    network_id: 3,
    gas: 4700000
  },
  main: {
    provider: () => new HDWalletProvider(
      mnemonic,
      "https://mainnet.infura.io/v3/e8cc7c8e245b46b482873ce9382a542b",
    ),
    network_id: 5,
    gas: 4700000
  },
  contracts_directory: './src/contracts/',
  contracts_build_directory: './src/abis/',
  compilers: {
    solc: {
      optimizer: {
        enabled: true,
        runs: 200
      },
      evmVersion: "petersburg"
    }
  }
}
