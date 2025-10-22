// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title ICharacterManager
/// @notice Interface for character and registration logic.
interface ICharacterManager {
    event Registered(address indexed user, string name, uint8 characterType);

    function register(string calldata name, uint8 characterType) external;
    function getProfile(address user) external view returns (
        string memory name,
        uint8 characterType,
        uint32 level,
        uint256 xp,
        bool registered
    );
}
