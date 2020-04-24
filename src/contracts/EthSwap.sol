pragma solidity ^0.5.16;

import "./Token.sol";

contract EthSwap {
  string public name = "EthSwap Instant Exchange";
  Token public token;
  uint public rate = 1000000000;
  address private owner;



  event TokensPurchased(
    address account,
    address token,
    uint amount,
    uint rate
  );

  event TokensSold(
    address account,
    address token,
    uint amount,
    uint rate
  );

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(msg.sender == owner, 'you must be the owner');
    _;
  }


  constructor (Token _token) public {
    token = _token;
  }

  function () external payable {
    buyTokens();
  }

  function buyTokens() public payable {
    // Calculate the number of tokens to buy
    uint tokenAmount = msg.value * rate;

    // Require that EthSwap has enough tokens
    require(token.balanceOf(address(this)) >= tokenAmount, '[ERROR]::NEED_MORE_ETHER');

    // Transfer tokens to the user
    token.transfer(msg.sender, tokenAmount);

    // Emit an event
    emit TokensPurchased(msg.sender, address(token), tokenAmount, rate);
  }

  function sellTokens(uint _amount) public onlyOwner {
    // User can't sell more tokens than they have
    require(token.balanceOf(msg.sender) >= _amount, '[ERROR]::NOT_ENOUGH_TO_SELL');

    // Calculate the amount of Ether to redeem
    uint etherAmount = _amount / rate;

    // Require that EthSwap has enough Ether
    require(address(this).balance >= etherAmount, '[ERROR]::EXCHANGE_NEEDS_MORE_ETHER');

    // Perform sale
    token.transferFrom(msg.sender, address(this), _amount);
    msg.sender.transfer(etherAmount);

    // Emit an event
    emit TokensSold(msg.sender, address(token), _amount, rate);
  }

}
