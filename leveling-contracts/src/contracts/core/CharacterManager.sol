// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../storage/UserStorage.sol";
import "../utils/Errors.sol";
import "../interfaces/ICharacterManager.sol";

/// @title CharacterManager
/// @notice Handles player registration and character selection.
abstract contract CharacterManager is UserStorage, ICharacterManager {

    /// @notice Registers a new user with a chosen character type.
    /// @dev Only one-time registration per wallet.
    function register(string calldata name, uint8 characterType) public virtual {
        if (_users[msg.sender].registered) revert AlreadyRegistered();
        if (characterType < 1 || characterType > 2) revert InvalidCharacter();

        _users[msg.sender] = UserProfile({
            name: name,
            characterType: characterType,
            level: 1,
            xp: 0,
            registered: true
        });

        emit Registered(msg.sender, name, characterType);
    }

    /// @notice Internal helper to enforce registration requirement.
    function _requireRegistered(address user) internal view virtual {
        if (!_users[user].registered) revert NotRegistered();
    }

    /// @notice Returns the profile data for a given user.
    function getProfile(address user) external view virtual returns (
        string memory name,
        uint8 characterType,
        uint32 level,
        uint256 xp,
        bool registered
    ) {
        UserProfile storage u = _users[user];
        return (u.name, u.characterType, u.level, u.xp, u.registered);
    }
}
