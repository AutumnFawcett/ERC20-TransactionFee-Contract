// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract ERC20 {
    // 🔁 Event triggered when tokens are transferred
    event Transfer(address indexed from, address indexed to, uint256 value);

    // ✅ Event triggered when an allowance is set by an owner for a spender
    event Approval(address indexed owner, address indexed spender, uint256 value);

     // Token metadata
    string public constant name = "MyTokenName"; // Token name
    string public constant symbol = "MTN";  // Token ticker symbol
    uint8 public constant decimals = 18; // Number of decimals (like cents in a dollar)

    // 📦 Total number of tokens in circulation
    uint256 public totalSupply;

    // 👑 Contract owner address (set on deployment)
    address public owner;

    // 💸 Address that receives the 1% fee from every transfer
    address public feeCollector = 0xA26D8AF9d02Dc35c1BC05bD46528B24b71B83d96; // <-- Replace with your address

    // 📊 Mapping of user balances
    mapping(address => uint256) public balanceOf;

    // 🧾 Mapping of allowances: owner => (spender => amount)
    mapping(address => mapping(address => uint256)) public allowance;

    // 🏗 Constructor sets the deployer as the owner
    constructor() {
        owner = msg.sender;
    }

    // 🔒 Modifier restricts function access to only the owner
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

     // 🔁 Public transfer function — allows msg.sender to send tokens
    function transfer(address to, uint256 value) external returns (bool) {
        return _transfer(msg.sender, to, value);
    }

    // 🏦 transferFrom lets a spender transfer tokens on behalf of an owner (if approved)
    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        require(allowance[from][msg.sender] >= value, "ERC20: Insufficient Allowance");
        
        // Decrease the allowance by the amount being spent
        allowance[from][msg.sender] -= value;
       
        // Emit updated allowance
        emit Approval(from, msg.sender, allowance[from][msg.sender]);
        
        return _transfer(from, to, value);
    }

    // 🔒 Internal function to handle token transfers, including fee deduction
    function _transfer(address from, address to, uint256 value) private returns (bool) {
        require(balanceOf[from] >= value, "ERC20: Insufficient sender balance");

        uint256 fee = value / 100; // Calculate 1% fee
        uint256 amountAfterFee = value - fee; // What the recipient will get

        balanceOf[from] -= value;
        balanceOf[to] += amountAfterFee;
        balanceOf[feeCollector] += fee; // Send fee to feeCollector

        emit Transfer(from, to, amountAfterFee);
        emit Transfer(from, feeCollector, fee);

        return true;
    }
    // ✅ Approve a spender to use your tokens up to a specified amount
    function approve(address spender, uint256 value) external returns (bool) {
        allowance[msg.sender][spender] += value;
        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);
        return true;
    }

    // 👑 Owner-only minting 👑 Only the owner can mint new tokens to an address
    function mint(address to, uint256 amount) external onlyOwner {
        balanceOf[to] += amount; // Increase recipient balance
        totalSupply += amount; // Increase total token supply
        emit Transfer(address(0), to, amount); // Optional: shows mint in logs... Shows minting as a transfer from "zero address"
    }
}
