pragma solidity ^0.5.0;

contract Crowdsale {
     // State variables
    bool public isCompleted;
    bool public isIcoRunning;
    bool public isIcoBonusRunning;
    //uint256 public icoStartTime;
    //uint256 public icoEndTime;
    uint256 public tokenRate;
    address public tokenAddress;
    uint256 public fundingGoal;
    address payable public owner;

    /**
    * @dev To keep things organized I added a function to distrubute the ether
    *       after the ICO is completed with the modifier and adds an extra layer
    *       of security
    */
    modifier whenIcoCompleted {
        require(isCompleted == true, '[CROWDSALE]::CROWDSALE_IS_NOT_COMPLETED');
        _;
    }

    modifier onlyOwner {
        require(msg.sender == owner, '[CROWDSALE]::YOUR_NOT_THE_OWNER');
        _;
    }

     /**
    * @dev fallback buy function
    */
    function () external payable {
        buy();
    }


    // Constructor - Runs once on deploy
    constructor (
        bool _isRunning,
        uint256 _tokenRate,
        address _tokenAddress,
        uint256 _fundingGoal
    ) public {
        require(_isRunning == true &&
                _tokenRate != 0 &&
                _tokenAddress != address(0) &&
                _fundingGoal != 0, '[CROWDSALE]::YOU_HAVE_ISSUES_WITH_PARAMS');

        //icoStartTime = _icoStart;
        //icoEndTime = _icoEnd;
        tokenRate = _tokenRate;
        tokenAddress = _tokenAddress;
        fundingGoal = _fundingGoal;
        owner = msg.sender;
    }

    /**
    * @dev buy function
    *  1 Full ETH = 1e18 Pieces of ETH or Wei
    *  1 Full token = 1 Full ETH * 1e18 Pieces of Token / 1e18 Wei
    */
    function buy() public payable {
        uint256 tokensToBuy;
        tokensToBuy = msg.value * 1e18 / 1 ether * tokenRate;

        
    }

    //1 Full ETH = 1 Token * 1e18 Wei / 1e5 Pieces of token / TokenRate
    function sell() public payable {
        uint256 tokensToConvert = 10; // Sample tokens
        uint256 weiFromTokens;
        weiFromTokens = tokensToConvert * 1 ether / tokenRate / 1e18;
    }

    /**
    * @dev extract the ether after the ICO is completed
    */
    function extractEther() public whenIcoCompleted {
        owner.transfer(address(this).balance);
    }
}