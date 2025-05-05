# ERC20-TransactionFee-Contract
This is my own updated version of the "ERC20contractAssignment" to make a working contract not just a testing contract. I have also deployed it using Sepolia.

### Main Changes:   
**Upgrades to my ERC-20 contract:**  
✅ Real totalSupply tracking  
💸 Fee mechanism  
👑 Owner-only minting  

<br>  

> [!NOTE]
> Check out my updated ERC20 "1% Transaction Fee" Contract Deployed with Sepolia
> on [Etherscan](https://sepolia.etherscan.io/tx/0xc02693694e2dba971dae3e110434ec055efbc2d7d5275181fee0dabdcd1407b2)
<br>
<br>

## Detailed Updates to my ERC20 "1% Transaction Fee" Contract: 

<br> 

**✅ 1. Track totalSupply When Minting**  
Update ```giveMeOneToken()``` to also increase ```totalSupply```:   

``` 
function giveMeOneToken() external {
    balanceOf[msg.sender] += 1e18;
    totalSupply += 1e18;
}
```
<br>

**💸 2. Added a Fee Mechanism to ```_transfer()```**  
At the top of the contract, I added a ```feeCollector``` address:
```
address public feeCollector = 0xYourAddressHere;
```
Then modify ```_transfer()``` like this:
```
function _transfer(address from, address to, uint256 value) private returns (bool) {
    require(balanceOf[from] >= value, "ERC20: Insufficient balance");

    uint256 fee = value / 100; // 1%
    uint256 amountAfterFee = value - fee;

    balanceOf[from] -= value;
    balanceOf[to] += amountAfterFee;
    balanceOf[feeCollector] += fee;

    emit Transfer(from, to, amountAfterFee);
    emit Transfer(from, feeCollector, fee);

    return true;
}
```

<br>

**👑 3. Add Owner-Only Minting**   
Declared an ```owner``` and use ```modifier``` to restrict access:
```
address public owner;

constructor() {
    owner = msg.sender;
}

modifier onlyOwner() {
    require(msg.sender == owner, "Not the owner");
    _;
}
```  
changed ```giveMeOneToken()``` to only be callable by the owner:  
```
function mint(address to, uint256 amount) external onlyOwner {
    balanceOf[to] += amount;
    totalSupply += amount;
}
```

<br>

**That’s it! A production-style token with:**  

- Real total supply tracking

- 1% transaction fees

- Owner-controlled minting

<br>

## What my Updated ERC20 "1% Transaction Fee" Contract does line by line: 

