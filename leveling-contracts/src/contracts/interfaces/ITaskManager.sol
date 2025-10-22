// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title ITaskManager
/// @notice Interface for managing task definitions and user progress tracking.
interface ITaskManager {
    event TaskDefCreated(uint256 indexed taskId, string name);
    event TaskDefUpdated(uint256 indexed taskId);
    event TaskCompleted(address indexed user, uint32 day, uint256 indexed taskId, uint16 progress, uint16 goal, uint256 xpAwarded);
    event TaskProgressed(address indexed user, uint32 day, uint256 indexed taskId, uint16 oldProgress, uint16 newProgress);

    function createTaskDef(string calldata name, uint8 ttype, uint16 goal, uint16 xp, bool enabled) external returns (uint256);
    function updateTaskDef(uint256 taskId, string calldata name, uint8 ttype, uint16 goal, uint16 xp, bool enabled) external;

    function getTaskDef(uint256 taskId) external view returns (string memory, uint8, uint16, uint16, bool);
    function taskDefCount() external view returns (uint256);

    function addProgress(uint256 taskId, uint16 amount) external;
    function getProgress(address user, uint32 day, uint256 taskId) external view returns (uint16, bool);
}
