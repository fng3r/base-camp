// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.26;

/**
 * @title BasicMath
 */
contract BasicMath {

    uint256 number;

    /**
     * @param _a first value
     * @param _b second value
     */
    function adder(uint256 _a, uint256 _b) external pure returns (uint256 sum, bool error) {
        unchecked {
            sum = _a + _b;
            if (sum >= _a) {
                error = false;
            } else {
                sum = 0;
                error = true;
            }
        }
    }

    /**
     * @param _a first value
     * @param _b second value
     */
    function subtractor(uint256 _a, uint256 _b) external pure returns (uint256 difference, bool error) {
        unchecked {
            difference = _a - _b;
            if (difference <= _a) {
                error = false;
            } else {
                difference = 0;
                error = true;
            }
        }

    }
}