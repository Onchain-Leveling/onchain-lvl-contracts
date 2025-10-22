// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title ILevelManager
/// @notice Interface for XP and leveling system.
interface ILevelManager {
    event XPAwarded(address indexed user, uint256 amount, uint256 totalXp, uint32 newLevel);

    function xpOf(address user) external view returns (uint256);
    function levelOf(address user) external view returns (uint32);
    function nextLevelXp(address user) external view returns (uint256 remaining, uint256 nextLevelCumulative);
}
