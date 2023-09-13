// SPDX-License-Identifier: GPL-3.0-or-later

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract IPT is ERC20 {
    constructor() ERC20("Idea Property Token", "IPT") {
        // mint 1,000,000,000 tokens to the deployer's address
        _mint(msg.sender, 1 * 1e9 * 1e18);
    }
    
    using SafeMath for uint256;
    
    // burn counter
    uint256 private _burnTotal;

    // direct burn
    function burn(uint256 amount) public {
        _burn(_msgSender(), amount);
        _burnTotal = _burnTotal.add(amount);
    }

    // interactive burn
    function burnFrom(address account, uint256 amount) public {
        uint256 decreasedAllowance = allowance(account, _msgSender()).sub(
            amount,
            'ERC20: burn amount exceeds allowance'
        );

        _approve(account, _msgSender(), decreasedAllowance);
        _burn(account, amount);
        _burnTotal = _burnTotal.add(amount);
    }

    // view burn total
    function totalTokensBurned() public view returns (uint256) {
        return _burnTotal;
    }
}
