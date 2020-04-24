const Token = artifacts.require("Token");
const EthSwap = artifacts.require("EthSwap");
//const Crowdsale = artifacts.require("Crowdsale");

module.exports = async function(deployer) {
  // Deploy Token
  await deployer.deploy(Token);
  const token = await Token.deployed();

  // Deploy EthSwap
  await deployer.deploy(EthSwap, token.address);
  const ethSwap = await EthSwap.deployed();

  //await deployer.deploy(Crowdsale, true, '1000', '0x53E3e92b5335261681D4BC95030F433DaA24E8b1', '500000');

  //! token transfers
  // Transfer tokens to EthSwap for sale (100 Million Tokens)
  await token.transfer(ethSwap.address, '100000000000000000000000000');

  // Transfer the reserve wallet ( Million Tokens)
  await token.transfer('', '650000000000000000000000000');

  // Transfer the dev Jason shares (15 Million Tokens)
  await token.transfer('', '15000000000000000000000000');

  // Transfer the founder James shares (15 Million Tokens)
  await token.transfer('', '15000000000000000000000000');

  // Transfer the dev Dave shares (15 Million Tokens)
  await token.transfer('', '15000000000000000000000000');

  // Transfer other misc (5 Million Tokens)
  await token.transfer('', '5000000000000000000000000')

  // Transfer marketing/bounties/development shares (100 Million Tokens)
  await token.transfer('', '100000000000000000000000000')
};
