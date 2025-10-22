// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title XPUtils
/// @notice Utility library for XP and leveling calculations.
library XPUtils {
    uint256 internal constant BASE_XP_PER_LEVEL = 300;
    uint256 internal constant LINEAR_STEP = 150;

    /// @notice Returns the cumulative XP required to reach a given level.
    function cumulativeXpForLevel(uint256 level) internal pure returns (uint256) {
        if (level <= 1) return 0;
        uint256 n = level - 1;
        uint256 first = BASE_XP_PER_LEVEL;
        uint256 d = LINEAR_STEP;
        return (n * (2 * first + (n - 1) * d)) / 2;
    }

    /// @notice Returns XP needed to advance from the current level to the next.
    function deltaXpForNextLevel(uint256 currentLevel) internal pure returns (uint256) {
        return BASE_XP_PER_LEVEL + (currentLevel - 1) * LINEAR_STEP;
    }
}
