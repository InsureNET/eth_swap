const Token = artifacts.require("Token");
const EthSwap = artifacts.require("EthSwap");

module.exports = async function(deployer) {
  // Deploy Token
  await deployer.deploy(Token);
  const token = await Token.deployed();

  // Deploy EthSwap
  await deployer.deploy(EthSwap, token.address);
  const ethSwap = await EthSwap.deployed();

  // Transfer all tokens to EthSwap (900 million)
  await token.transfer(ethSwap.address, '900000000000000000000000000');

  // Transfer the dev shares
  await token.transfer('0x6F7d7d68c3Eed4Df81CF5F97582deef8ABC51533', '1500000000000000000000000');

  // Transfer the founders shares
  await token.transfer('0x53E3e92b5335261681D4BC95030F433DaA24E8b1', '8500000000000000000000000');

  //await token.transfer('0x51Caa385AB6363F6dF543BaEbe9501F057A8638e', '25000000000000000000000000');await token.transfer('0x51Caa385AB6363F6dF543BaEbe9501F057A8638e', '25000000000000000000000000');
};
