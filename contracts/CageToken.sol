// SPDX-License-Identifier: MIT
pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";

contract CageToken is IERC20, Ownable, Pausable {
    using SafeMath for uint256;
    using Address for address;
    using SafeERC20 for IERC20;

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private _name = "Cage Token";
    string private _symbol = "CAGE";
    uint8 private _decimals = 18;
    uint256 public TOTAL_SUPPLY = 1000000000000000 ether;

    constructor() public {
        _totalSupply = TOTAL_SUPPLY;
        _balances[msg.sender] =  TOTAL_SUPPLY;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function decimals() external view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public override view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public override view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount)
        public
        virtual
        override
        whenNotPaused
        returns (bool)
    {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override whenNotPaused returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            msg.sender,
            _allowances[sender][msg.sender].sub(
                amount,
                "CageToken: TRANSFER_AMOUNT_EXCEEDS_ALLOWANCE"
            )
        );
        return true;
    }

    function allowance(address owner, address spender)
        public
        virtual
        override
        view
        returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount)
        public
        virtual
        override
        whenNotPaused
        returns (bool)
    {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue)
        public
        virtual
        whenNotPaused
        returns (bool)
    {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender].add(addedValue)
        );
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue)
        public
        virtual
        whenNotPaused
        returns (bool)
    {
        _approve(
            msg.sender,
            spender,
            _allowances[msg.sender][spender].sub(
                subtractedValue,
                "CageToken: DECREASED_ALLOWANCE_BELOW_ZERO"
            )
        );
        return true;
    }

    function withdraw(address token, uint256 amount) public onlyOwner {
        IERC20(token).safeTransfer(msg.sender, amount);
    }

    function pause() public onlyOwner whenNotPaused {
        _pause();
    }

    function unpause() public onlyOwner whenPaused {
        _unpause();
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(
            sender != address(0),
            "CageToken: TRANSFER_FROM_THE_ZERO_ADDRESS"
        );
        require(
            recipient != address(0),
            "CageToken: TRANSFER_TO_THE_ZERO_ADDRESS"
        );

        _balances[sender] = _balances[sender].sub(
            amount,
            "CageToken: TRANSFER_AMOUNT_EXCEEDS_BALANCE"
        );
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "CageToken: APPROVE_FROM_THE_ZERO_ADDRESS");
        require(spender != address(0), "CageToken: APPROVE_TO_THE_ZERO_ADDRESS");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
}
