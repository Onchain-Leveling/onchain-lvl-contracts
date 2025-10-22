// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title UserStorage
/// @notice Defines persistent data structure for user profiles.
abstract contract UserStorage {
    struct UserProfile {
        string name;
        uint8 characterType; // 1 = Degen, 2 = Runner
        uint32 level;
        uint256 xp;
        bool registered;
    }

    mapping(address => UserProfile) internal _users;
}
