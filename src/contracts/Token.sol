pragma solidity ^0.5.16;

import "@openzeppelin/contracts/math/SafeMath.sol";

contract Token {
    using SafeMath for uint256;

    string  public name = "US Forestry Token";
    string  public symbol = "USF";
    uint256 public totalSupply = 10**9 * 10**18; // 1 billion tokens
    uint8   public decimals = 18;

    // Rates - ToDo: Get these figured out
    uint256 public lvl1Rate = 10000;
    uint256 public lvl2Rate = 9000;
    uint256 public lvl3Rate = 8000;
    uint256 public lvl4Rate = 7000;
    uint256 public lvl5Rate = 6000;
    uint256 public lvl6Rate = 5000;
    uint256 public lvl7Rate = 4000;
    uint256 public lvl8Rate = 3000;
    uint256 public lvl9Rate = 2000;
    uint256 public lvl10Rate = 1000;
    uint256 public lvl1R1ate = 100;

    // Limits per tier
    //uint256 public limitTierOne = 25e6 * (10 ** this.decimals);
    //uint256 public limitTierTwo = 50e6 * (10 ** this.decimals);
    //uint256 public limitTierThree = 75e6 * (10 ** this.decimals);
    //uint256 public limitTierFour = 100e6 * (10 ** this.decimals);
    // .....



    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor() public {
        balanceOf[msg.sender] = totalSupply;
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOf[msg.sender] >= _value, '[ERROR]::NOT_ENOUGH_ETHER');
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOf[_from], '[ERROR]::NOT_ENOUGH_ETHER');
        require(_value <= allowance[_from][msg.sender], '[ERROR]::NOT_ENOUGH_ALLOWANCEE');
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}