// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

/**
 * @title GarageManager
 */
contract GarageManager {

    struct Car {
        string make;
        string model;
        string color;
        uint256 numberOfDoors;
    }

    error BadCarIndex(uint _index);

    mapping (address => Car[]) garage;

    function addCar(string memory make, string memory model, string memory color, uint256 numberOfDoors) external {
        Car memory newCar = Car(make, model, color, numberOfDoors);
        garage[msg.sender].push(newCar);
    }

    function getMyCars() external view returns (Car[] memory) {
        return garage[msg.sender];         
    }

    function getUserCars(address _user) external view returns (Car[] memory) {
        return garage[_user];         
    }

    function resetMyGarage() external {
        delete garage[msg.sender];         
    }

    function updateCar(uint256 index, string memory make, string memory model, string memory color, uint256 numberOfDoors) external {
        if (index >= garage[msg.sender].length) {
            revert BadCarIndex(index);
        }

        garage[msg.sender][index] = Car(make, model, color, numberOfDoors);
    }
}