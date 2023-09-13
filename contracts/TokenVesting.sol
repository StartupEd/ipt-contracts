// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract TokenVesting {
    using SafeERC20 for IERC20;

    address public beneficiary;
    uint256 public cliff;
    uint256 public start;
    uint256 public duration;
    uint256 public initialBalance;
    uint256 public released;

    IERC20 public token;

    event TokensReleased(uint256 amount);

    constructor(
        address _token,
        address _beneficiary,
        uint256 _start,
        uint256 _cliff,
        uint256 _duration
    ) {
        require(_beneficiary != address(0), "TokenVesting: beneficiary is the zero address");
        require(_cliff <= _duration, "TokenVesting: cliff is longer than duration");

        token = IERC20(_token);
        beneficiary = _beneficiary;
        duration = _duration;
        cliff = _start + _cliff;
        start = _start;
    }

    function setInitialBalance() public {
        require(initialBalance == 0, "Initial balance already set");
        initialBalance = token.balanceOf(address(this));
    }

    function release() public {
        require(block.timestamp >= cliff, "TokenVesting: no tokens are due");
        uint256 amount = releasableAmount();
        require(amount > 0, "TokenVesting: no tokens are releasable");

        released += amount;
        token.safeTransfer(beneficiary, amount);
        emit TokensReleased(amount);
    }

    function releasableAmount() public view returns (uint256) {
        if (block.timestamp < cliff) {
            return 0;
        } else if (block.timestamp >= start + duration) {
            return token.balanceOf(address(this));
        } else {
            uint256 vestr = (initialBalance * (block.timestamp - start)) / duration;
            uint256 afterreleased = vestr - released;
            return afterreleased;
        }
    }
}
