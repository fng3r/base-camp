// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract ControlStructures {

    error AfterHours(uint256 _time);

    function fizzBuzz(uint256 _number) external pure returns (string memory) {
        if (_number % 15 == 0) {
            return "FizzBuzz";
        }
        
        if (_number % 3 == 0) {
            return "Fizz";
        }
        
        if (_number % 5 == 0) {
            return "Buzz";
        }

        return "Splat";
    }

    function doNotDisturb(uint256 _time) external pure returns (string memory result) {
        assert(_time < 2400);
        if (_time > 2200 || _time < 800) {
            revert AfterHours(_time);
        } else if (_time >= 1200 && _time <= 1259) {
            revert("At lunch!");
        } else if (_time >= 800 && _time <= 1199) {
            result = "Morning!";
        } else if (_time >= 1300 && _time <= 1799) {
            result = "Afternoon!";
        } else if (_time >= 1800 && _time <= 2200) {
            result = "Evening!";
        }
    }
}