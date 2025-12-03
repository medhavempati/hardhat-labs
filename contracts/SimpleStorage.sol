// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28; 

// The ^ indicates that any version newer than the specified version is alright
// Can use other logical operators too. Example: >=0.8.20 <0.9.0

contract SimpleStorage {
    // Main types of variables: boolean, uint, int, string, address, bytes

    // Uint default gets initialized to 0
    uint256 favoriteNumber;

    function simpleStore (uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }
}


