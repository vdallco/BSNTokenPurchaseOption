import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract cBSNOption {
    address public owner;
    address public BSN;
    address public cBSN;
    address public BURN_ADDRESS;
    uint256 public BSN_WETH_PRICE;
    uint256 public OPTION_DISCOUNT_DIVISOR;

    modifier onlyOwner() {
        require(msg.sender == owner, "onlyOwner");
        _;
    }

    constructor(address _cBSN, address _BSN, uint256 _BSN_WETH_PRICE, uint256 _OPTION_DISCOUNT_DIVISOR, address _BURN_ADDRESS) {
        owner = msg.sender;
        cBSN = _cBSN;
        BSN = _BSN;
        BSN_WETH_PRICE = _BSN_WETH_PRICE;
        OPTION_DISCOUNT_DIVISOR = _OPTION_DISCOUNT_DIVISOR;
        BURN_ADDRESS = _BURN_ADDRESS;
    }

    receive() external payable {
        revert(); // don't allow anyone to send ETH without using redeem_cBSN() payable function. There is no way to recover 
    }

    function withdrawTokens(address token, uint256 amount) external onlyOwner {
        require(ERC20(token).balanceOf(address(this)) >= amount, "insufficient contract balance for token");
        ERC20(token).transfer(owner, amount);
    }

    function setOwner(address newOwner) external onlyOwner {
        owner = newOwner;
    }

    function setBSN(address newBSN) external onlyOwner {
        BSN = newBSN;
    }

    function setcBSN(address newcBSN) external onlyOwner {
        cBSN = newcBSN;
    }

    function setBSNWETHPrice(uint256 newBSNWETHPrice) external onlyOwner{
        BSN_WETH_PRICE = newBSNWETHPrice;
    }

    function setBurnAddress(address newBurnAddress) external onlyOwner{
        BURN_ADDRESS = newBurnAddress;
    }

    function setOptionDiscountDivisor(uint256 newOptionDiscountDivisor) external onlyOwner{
        OPTION_DISCOUNT_DIVISOR = newOptionDiscountDivisor;
    }

    function depositBSN(uint256 bsnValue) public {
        ERC20(BSN).transferFrom(msg.sender, address(this), bsnValue);
    }

    function minimumETHforBSNRedemption(uint256 cBSNamount) public view returns(uint256) {
        uint256 marketPrice = (BSN_WETH_PRICE * cBSNamount) / (10**18);
        return marketPrice / OPTION_DISCOUNT_DIVISOR; // OPTION_DISCOUNT_DIVISOR = 2 for 50%
    }

    function redeem_cBSN(uint256 amount) public payable {
        require(address(this).balance >= msg.value, "insufficient eth balance in contract");
        require(ERC20(BSN).balanceOf(address(this)) >= amount, "not enough bsn in contract");
        require(msg.value > 0, "eth value must be greater than 0");
        uint256 minETH = minimumETHforBSNRedemption(amount);
        require(msg.value >= minETH, "eth value too small for redemption");
        ERC20(cBSN).transferFrom(msg.sender, BURN_ADDRESS, amount);
        ERC20(BSN).transfer(msg.sender, amount);
        payable(owner).transfer(msg.value);
    }
}