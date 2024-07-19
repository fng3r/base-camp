// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.26;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title AddressBook
 */
contract AddressBook is Ownable {
    struct Contact {
        uint256 id;
        string firstName;
        string lastName;
        uint256[] phoneNumbers;
    }

    error ContactNotFound(uint256 _id);

    mapping(uint256 => Contact) public contacts;

    uint256 private contactsCount;

    constructor(address owner)
        Ownable(owner) {}

    function addContact(uint256 _id, string memory _firstName, string memory _lastName, uint256[] memory _phoneNumbers) external onlyOwner {
        contacts[_id] = Contact(_id, _firstName, _lastName, _phoneNumbers);
        contactsCount++;
    }

    function deleteContact(uint256 _id) external onlyOwner {
        if (contacts[_id].id == 0) {
            revert ContactNotFound(_id);
        }

        delete contacts[_id];
        contactsCount--;
    }

    function getContact(uint256 _id) external view returns (Contact memory) {
        if (contacts[_id].id == 0) {
            revert ContactNotFound(_id);
        }

        return contacts[_id];
    }

    function getAllContacts() public view onlyOwner returns (Contact[] memory) {
        Contact[] memory _contacts = new Contact[](contactsCount);
        for (uint256 i = 0; i < contactsCount; i++) {
            _contacts[i] = contacts[i];
        }

        return _contacts;
    }
}


/**
 * @title AddressBookFactory
 */
contract AddressBookFactory {
    function deploy() external returns (address) {
        AddressBook addressBook = new AddressBook(msg.sender); 

        return address(addressBook);
    }
}