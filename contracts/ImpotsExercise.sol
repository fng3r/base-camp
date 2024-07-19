// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import "./SillyStringUtils.sol";

/**
 * @title ImportsExercise
 */
contract ImportsExercise {
    using SillyStringUtils for SillyStringUtils.Haiku;

    SillyStringUtils.Haiku public haiku;

    function saveHaiku(string memory _line1, string memory _line2, string memory _line3) external {
        haiku = SillyStringUtils.Haiku(_line1, _line2, _line3);
    }

    function getHaiku() external view returns (SillyStringUtils.Haiku memory) {
        return haiku;
    }

    function shruggieHaiku() external view returns (SillyStringUtils.Haiku memory _haiku) {
        _haiku = haiku;
        _haiku.line3 = SillyStringUtils.shruggie(_haiku.line3);

        return _haiku;
    }
}