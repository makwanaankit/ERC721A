require('@nomicfoundation/hardhat-toolbox');
require('@nomiclabs/hardhat-etherscan');
require('@openzeppelin/hardhat-upgrades');
/** @type import('hardhat/config').HardhatUserConfig */
// const { alchemyAPIkeyGoerli } = require('./secrets.json');
// const { deployerWalletPrivateKey } = require('./secrets.json');
// const { etherscanAPIkey } = require('./secrets.json');
module.exports = {
  solidity: '0.8.17',
  settings: {
    optimizer: {
      enabled: true,
      runs: 5000,
    },
  },
  networks: {
    hardhat: {
      chainId: 31337,
    },
    // goerli: {
    //   url: alchemyAPIkeyGoerli, //from infura
    //   accounts: [deployerWalletPrivateKey], //from metamask
    //   gas: 1000,
    // },
  },
  // etherscan: {
  //   apiKey: etherscanAPIkey,
  // },
  paths: {
    sources: './contracts',
    tests: './test',
    cache: './cache',
    artifacts: './artifacts',
  },
};
