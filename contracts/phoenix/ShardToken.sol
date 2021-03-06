pragma solidity ^0.8.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ShardToken is ERC20{
    // May be created by anyone
    constructor (string memory name_, string memory symbol_, uint256 supply_) ERC20(name_, symbol_) {
        _mint(
            msg.sender,
            supply_
        );
    }

    function decimals() public pure override returns (uint8) {
        return 18;
    }
}
