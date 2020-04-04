pragma solidity ^0.5.0;

import "./ERC20Mintable.sol";

contract USFToken is ERC20Mintable {
  string  public name;
  string  public symbol;
  uint256 public decimals;
  string  public standard;
  string  public statement;

  constructor () public {
    name = "US Forestry Token";
    symbol = "USF";
    decimals = 18;
    standard = "USF Token v1.0";
    statement = "Plant Trees";
  }
}
