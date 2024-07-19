// SPDX-License-Identifier: GPL-3.0

pragma solidity 0.8.26;

/**
 * @title ArraysExercise
 */
contract ArraysExercise {
    uint32 constant Y2KTimestamp = 946702800;

    uint256[] public numbers = [1,2,3,4,5,6,7,8,9,10];

    address[] public senders;
    uint256[] public timestamps;

    function getNumbers() public view returns (uint[] memory) {
        return numbers;
    }

    function resetNumbers() public {
        delete numbers;
        for (uint8 i = 1; i < 11; i++) 
        {
            numbers.push(i);
        }
    }

    function appendToNumbers(uint256[] calldata _toAppend) public {
        for (uint256 i = 0; i < _toAppend.length; i++) {
            numbers.push(_toAppend[i]);
        }
    }

    function saveTimestamp(uint256 _unixTimestamp) public {
        senders.push(msg.sender);
        timestamps.push(_unixTimestamp);
    }

    function resetSenders() public {
        delete senders;
    }

    function resetTimestamps() public {
        delete timestamps;
    }

    function afterY2K() public view returns (uint256[] memory, address[] memory) {
        uint256 count = _countTimestamps();

        uint256[] memory timestampsAfterY2K = new uint[](count);
        address[] memory sendersAfterY2K = new address[](count);
        uint256 index = 0;

        for (uint256 i = 0; i < timestamps.length; i++) 
        {
            if (timestamps[i] > Y2KTimestamp) {
                timestampsAfterY2K[index] = timestamps[i];
                sendersAfterY2K[index] = senders[i];
                index++;
            }
        }

        return (timestampsAfterY2K, sendersAfterY2K);
    }

    function _countTimestamps() private view returns (uint256) {
        uint256 count = 0;
        for (uint256 i = 0; i < timestamps.length; i++) 
        {
            if (timestamps[i] > Y2KTimestamp) {
                count++;
            }
        }

        return count;
    }
}