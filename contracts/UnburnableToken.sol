// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

/**
 * @title UnburnableToken
 */
contract UnburnableToken {
    mapping(address => uint256) public balances;

    mapping(address => bool) private hasClaimed;

    uint256 public totalSupply;
    uint256 public totalClaimed;

    error AllTokensClaimed();
    error TokensClaimed();

    error UnsafeTransfer(address _address);

    constructor() {
        totalSupply = 100_000_000;
    }

    function claim() external {
        if (hasClaimed[msg.sender]) {
            revert TokensClaimed();
        }

        if (totalClaimed >= totalSupply) {
            revert AllTokensClaimed();
        }

        hasClaimed[msg.sender] = true;
        balances[msg.sender] += 1000;
        totalClaimed += 1000;
    }

    function safeTransfer(address _to, uint256 _amount) external {
        if (_to == address(0) || _to.balance == 0) {
            revert UnsafeTransfer(_to);
        }

        balances[msg.sender] -= _amount;
        balances[_to] += _amount;
    }
}