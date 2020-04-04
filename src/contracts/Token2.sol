pragma solidity ^0.5.17;

/* taking ideas from FirstBlood token */
contract SafeMath {
    /*
    /*
    /* solidity is on 0.5.0 */
    function safeAdd(uint256 x, uint256 y) public pure returns(uint256) {
      uint256 z = x + y;
      assert((z >= x) && (z >= y));
      return z;
    }

    function safeSubtract(uint256 x, uint256 y) public pure returns(uint256) {
      assert(x >= y);
      uint256 z = x - y;
      return z;
    }

    function safeMult(uint256 x, uint256 y) public pure returns(uint256) {
      uint256 z = x * y;
      assert((x == 0)||(z/x == y));
      return z;
    }
}

contract Token is SafeMath {
    // metadata
    string  public _name = "US Forestry Token";
    string  public _symbol = "USF";
    uint256 public _totalSupply = 1000000000000000000000000000; // 1 billion tokens
    uint8   public _decimals = 18;
    string  public _version = 'version 1.0.0';
    address private _owner = 0x6F7d7d68c3Eed4Df81CF5F97582deef8ABC51533; //msg.sender;
    address private partner1 = 0x6F7d7d68c3Eed4Df81CF5F97582deef8ABC51533; // Jason
    address private partner2 = 0x6F7d7d68c3Eed4Df81CF5F97582deef8ABC51533; // James
    address private companyFund = 0x6F7d7d68c3Eed4Df81CF5F97582deef8ABC51533; // Company Wallet
    address private tokenSaleFund = 0x6F7d7d68c3Eed4Df81CF5F97582deef8ABC51533; // Sale Wallet
    address private ethSaleAddress = 0x6F7d7d68c3Eed4Df81CF5F97582deef8ABC51533; // Incoming ETH wallet

    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    // mappings
    mapping(address => uint256) private _balances;
    mapping(address => uint256) public balanceOfAccount;
    mapping(address => uint256) public freezeOf;
    mapping(address => mapping(address => uint256)) public _allowances;

    // contracts
    address public ethFundDeposit;
    address public usfFundDeposit;

    // crowdsale parameters
    bool public isFinalized;
    uint256 public fundingStartBlock;
    uint256 public fundingEndBlock;
    uint256 public investmentMinimum = 1570000000000000000; // 1.57 ETH in WEI
    uint256 public constant usfFund = 900000000000000000000000000;  // 900m USF reserved for US Forestry Foundation use.
    // ToDo: set up the increasing exchange rate to increase every 500K tokens
    uint256 public tokenExchangeRate = 5000;// 5000 USF Tokens per ETH

    // Cap it at 1 Billion tokens
    uint256 public constant tokenCreationCap = 1000000000000000000000000000;

    // ** EVENTS **
    // log the transfer function
    event Transfer(
        address indexed _from,
        address indexed _to,
        uint256 _value
    );

    // log the approval function
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    // log the mint function every time the contract mints tokens
    event CreateUSF(
        address indexed _to,
        uint256 _value
    );

    // log every refund if the sale fails
    event LogRefund(
        address indexed _to,
        uint256 _value
    );

    event Burn(
        address indexed _from,
        uint256 _value
    );


    constructor(string memory name, string memory symbol, uint8 decimals, uint256 totalSupply) public {
        // set the total supply and send it to owner account???
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _totalSupply;
        
        //balanceOfAccount[msg.sender] += totalSupply;

        // todo: deposit founders, owners, partners shares
        


    }

    // ToDo: Add onlyOwner
    // @dev accepts ether and mints tokens to the msg.sender and uses the msg.value passed
    function createTokens(address _to, uint256 _value) public payable {
        require(isFinalized, 'USFToken Contract: Sale has been finalized!');
        require(block.number < fundingStartBlock, 'USFToken Contract: Sorry, you cannot cheat!');
        require(block.number > fundingEndBlock, 'USFToken Contract: Sorry, you cannot cheat!');
        require(msg.value == 0, 'USFToken Contract: You need money, silly...');

        //uint256 tokens =
        // make sure they have enough
        require(balanceOfAccount[msg.sender] >= _value, 'USFToken Contract: not enough ether');
        balanceOfAccount[msg.sender] += _value;
        emit CreateUSF(_to, _value);
    }

    /** @dev Creates `amount` tokens and assigns them to `account`, increasing
     * the total supply.
     *
     * Emits a {Transfer} event with `from` set to the zero address.
     *
     * Requirements
     *
     * - `to` cannot be the zero address.
     */
    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        // Call hooks...
        _beforeTokenTransfer(address(0), account, amount);

        // Increase the toalSupply and account the tokens will be transferred to.
        _totalSupply = _totalSupply += amount;
        _balances[account] = _balances[account] += amount;
        emit Transfer(address(0), account, amount);
    }

    /**
     * @dev See {IERC20-balanceOf}.
     */
    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
     * @dev See {IERC20-transfer}.
     *
     * Requirements:
     *
     * - `recipient` cannot be the zero address.
     * - the caller must have a balance of at least `amount`.
     */
    function transfer(address _to, uint256 _value) public returns (bool success) {
        require(balanceOfAccount[msg.sender] >= _value, 'not enough ether');
        balanceOfAccount[msg.sender] -= _value;
        balanceOfAccount[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    /**
    * @dev See {IERC20-approve}.
    *
    * Requirements:
    *
    * - `spender` cannot be the zero address.
    */
    function approve(address _spender, uint256 _value) public returns (bool success) {
        _allowances[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    /**
     * @dev See {IERC20-allowance}.
     */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
     * @dev See {IERC20-transferFrom}.
     *
     * Emits an {Approval} event indicating the updated allowance. This is not
     * required by the EIP. See the note at the beginning of {ERC20};
     *
     * Requirements:
     * - `sender` and `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     * - the caller must have allowance for `sender`'s tokens of at least
     * `amount`.
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        require(_value <= balanceOfAccount[_from], 'USFToken Contract: not enough ether buddy');
        require(_value <= _allowances[_from][msg.sender], 'USFToken Contract: over your allowance');
        balanceOfAccount[_from] -= _value;
        balanceOfAccount[_to] += _value;
        _allowances[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    /**
     * @dev Atomically increases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        // call approve with the passed in value of increased amount (addedValue)
        _approve(msg.sender, spender, _allowances[msg.sender][spender] += addedValue);
        return true;
    }

    /**
     * @dev Atomically decreases the allowance granted to `spender` by the caller.
     *
     * This is an alternative to {approve} that can be used as a mitigation for
     * problems described in {IERC20-approve}.
     *
     * Emits an {Approval} event indicating the updated allowance.
     *
     * Requirements:
     *
     * - `spender` cannot be the zero address.
     * - `spender` must have allowance for the caller of at least
     * `subtractedValue`.
     */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        // call approve with the passed in value with the decreased amount (subtractedValue)
        _approve(msg.sender, spender, _allowances[msg.sender][spender] -= subtractedValue);
        return true;
    }

    /**
     * @dev Moves tokens `amount` from `sender` to `recipient`.
     *
     * This is internal function is equivalent to {transfer}, and can be used to
     * e.g. implement automatic token fees, slashing mechanisms, etc.
     *
     * Emits a {Transfer} event.
     *
     * Requirements:
     *
     * - `sender` cannot be the zero address.
     * - `recipient` cannot be the zero address.
     * - `sender` must have a balance of at least `amount`.
     */
    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "USFToken Contract: transfer from the zero address");
        require(recipient != address(0), "USFToken Contract: transfer to the zero address");
        require(balanceOfAccount[msg.sender] >= amount, "USFToken Contract:: transfer amount exceeds balance");
        _beforeTokenTransfer(sender, recipient, amount);

        _balances[sender] = _balances[sender] -= amount;
        //_balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    /**
     * @dev Destroys `amount` tokens from `account`, reducing the
     * total supply.
     *
     * Emits a {Transfer} event with `to` set to the zero address.
     *
     * Requirements
     *
     * - `account` cannot be the zero address.
     * - `account` must have at least `amount` tokens.
     */
    function _burn(address account, uint256 amount) internal {
        require(account != address(0), "USFToken Contract: cannot burn from the zero address");

        // Call hooks
        _beforeTokenTransfer(account, address(0), amount);

        // update the balances of the account and totalsupply
        _balances[account] = _balances[account] -= amount;
        _totalSupply = _totalSupply -= amount;
        emit Transfer(account, address(0), amount);
    }

    /**
     * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
     *
     * This is internal function is equivalent to `approve`, and can be used to
     * e.g. set automatic allowances for certain subsystems, etc.
     *
     * Emits an {Approval} event.
     *
     * Requirements:
     *
     * - `owner` cannot be the zero address.
     * - `spender` cannot be the zero address.
     */
    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "USFToken Contract: approve from the zero address");
        require(spender != address(0), "USFToken Contract: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    /**
     * @dev Hook that is called before any transfer of tokens. This includes
     * minting and burning.
     *
     * Calling conditions:
     *
     * - when `from` and `to` are both non-zero, `amount` of `from`'s tokens
     * will be to transferred to `to`.
     * - when `from` is zero, `amount` tokens will be minted for `to`.
     * - when `to` is zero, `amount` of `from`'s tokens will be burned.
     * - `from` and `to` are never both zero.
     *
     * To learn more about hooks, head to xref:ROOT:using-hooks.adoc[Using Hooks].
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount) internal {
        // Add any hooks we want to call before any token transfers. ie: check for owner.

     }
}



