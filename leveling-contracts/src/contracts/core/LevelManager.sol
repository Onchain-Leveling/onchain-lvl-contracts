// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../storage/UserStorage.sol";
import "../storage/LevelStorage.sol";
import "../utils/XPUtils.sol";
import "../utils/Errors.sol";

/// @title LevelManager
/// @notice Manages XP accumulation and level progression.
abstract contract LevelManager is UserStorage, LevelStorage {
    event XPAwarded(address indexed user, uint256 amount, uint256 totalXp, uint32 newLevel);

    function xpOf(address user) public view returns (uint256) {
        return _users[user].xp;
    }

    function levelOf(address user) public view returns (uint32) {
        return _users[user].level;
    }

    /// @notice Returns remaining XP to next level and next cumulative XP milestone.
    function nextLevelXp(address user) external view returns (uint256 remaining, uint256 nextLevelCumulative) {
        if (!_users[user].registered) return (0, 0);
        uint32 lvl = _users[user].level;
        uint256 nextCum = XPUtils.cumulativeXpForLevel(lvl + 1);
        uint256 currentXp = _users[user].xp;
        remaining = nextCum > currentXp ? (nextCum - currentXp) : 0;
        return (remaining, nextCum);
    }

    /// @dev Internal method to increase XP and auto-level up if threshold reached.
    function _awardXp(address user, uint256 amount) internal {
        _requireRegistered(user);
        if (amount == 0) return;

        _users[user].xp += amount;

        // Continuous leveling in case XP crosses multiple thresholds.
        while (_users[user].xp >= XPUtils.cumulativeXpForLevel(_users[user].level + 1)) {
            _users[user].level += 1;
        }

        emit XPAwarded(user, amount, _users[user].xp, _users[user].level);
    }

    function _requireRegistered(address user) internal view virtual;
}
