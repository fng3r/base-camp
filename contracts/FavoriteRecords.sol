// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

/**
 * @title FavoriteRecords
 */
contract FavoriteRecords {
    string[] private recordsNames;

    mapping(string => bool) public approvedRecords;
    mapping(address => mapping(string => bool)) public userFavorites;

    error NotApproved(string recordName);

    constructor() {
        recordsNames = [
            "Thriller",
            "Back in Black",
            "The Bodyguard",
            "The Dark Side of the Moon",
            "Their Greatest Hits (1971-1975)",
            "Hotel California",
            "Come On Over",
            "Rumours",
            "Saturday Night Fever"
        ];
        for (uint256 i = 0; i < recordsNames.length; i++) {
            approvedRecords[recordsNames[i]] = true;
        }
    }

    function getApprovedRecords() public view returns (string[] memory) {
        return recordsNames;
    }

    function addRecord(string calldata _recordName) public {
        if (!approvedRecords[_recordName]) {
            revert NotApproved(_recordName);
        }

        userFavorites[msg.sender][_recordName] = true;
    }

    function getUserFavorites(address _user) public view returns (string[] memory) {
        uint256 count;
        for (uint256 i = 0; i < recordsNames.length; i++) {
            if (userFavorites[_user][recordsNames[i]]) {
                count++;
            }
        }

        string[] memory userFavoritesNames = new string[](count);
        if (count != 0) {
            uint256 userFavoritesNamesCount;
            for (uint256 i = 0; i < recordsNames.length; i++) {
                if (userFavorites[_user][recordsNames[i]]) {
                    userFavoritesNames[userFavoritesNamesCount] = recordsNames[i];
                    userFavoritesNamesCount++;
                }
            }
        }

        return userFavoritesNames;
    }

    function resetUserFavorites() public {
        for (uint256 i = 0; i < recordsNames.length; i++) {
            userFavorites[msg.sender][recordsNames[i]] = false;
        }
    }
}