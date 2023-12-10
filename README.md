# BSNTokenPurchaseOption
Solidity smart contract designed to offer an option-to-purchase Blockswap Network's BSN governance tokens for 50% of on-chain recorded Uniswap pool price for early holders of the cBSN token

# Sepolia test tokens

| Token       | Contract address                           |
|-------------|--------------------------------------------|
| cBSN        | 0xDf9D739f801383Ad0EE87e6BF2DE878ea5183b9c |
| BSN         | 0x5B176E6543030E48681D149181723db98574cfF6 |
| cBSNOption  | 0x2e0078A0784F21749790aF5B67613656004205BC |
| BurnAddress | 0x000000000000000000000000000000000000dEaD |

# Functions

- constructor(address _cBSN, address _BSN, uint256 _BSN_WETH_PRICE, uint256 _OPTION_DISCOUNT_DIVISOR, address _BURN_ADDRESS)
- receive() external payable
- withdrawTokens(address token, uint256 amount) external onlyOwner
- setOwner(address newOwner) external onlyOwner
- setcBSN(address newcBSN) external onlyOwner 
- setBSNWETHPrice(uint256 newBSNWETHPrice) external onlyOwner
- setBurnAddress(address newBurnAddress) external onlyOwner
- setOptionDiscountDivisor(uint256 newOptionDiscountDivisor) external onlyOwner
- depositBSN(uint256 bsnValue) public
- minimumETHforBSNRedemption(uint256 cBSNamount) public view returns(uint256)
- redeem_cBSN(uint256 amount) public payable

# Test

Notes:
- Test price (BSN/WETH): 0.000001 WETH or 1000000000000 wei
- Redeeming 1 cBSN for 1 BSN should cost 0.0000005 ETH or 500000000000 wei
- 1000000000000000000 wei = 1 BSN = 1 cBSN

1. Approve BSN Spend on cBSNOption contract for 1000000000000000000 wei or 1 BSN
2. depositBSN(value) on cBSNOption contract for 1000000000000000000 wei or 1 BSN
3. Approve cBSN Spend on cBSNOption contract for 1000000000000000000 wei or 1 BSN
4. redeem_cBSN(cBSNvalue) on cBSNOption contract (sending 1 cBSN and 0.0000005 ETH to contract)

# Test result

1 cBSN was burned, 1 BSN was sent to the redeemer, and 0.0000005 ETH was sent to the contract owner:

https://sepolia.etherscan.io/tx/0x45e960abc710f2cb62f3b19f283a13dd43219c49c7465a7352daa9a68ea0d543

