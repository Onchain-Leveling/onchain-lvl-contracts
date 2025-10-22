// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @title TaskStorage
/// @notice Persistent storage layout for task definitions and user progress.
abstract contract TaskStorage {
    enum TaskType { Running, Walking, Situps }

    struct TaskDef {
        string name;
        TaskType ttype;
        uint16 goal;
        uint16 xp;
        bool enabled;
    }

    mapping(uint256 => TaskDef) internal _taskDefs;
    uint256 internal _taskDefCount;

    struct UserTaskProgress {
        uint16 progress;
        bool completed;
    }

    mapping(address => mapping(uint32 => mapping(uint256 => UserTaskProgress))) internal _progress;

    /// @notice Returns the current UTC day index used for daily tracking.
    function _today() internal view returns (uint32) {
        return uint32(block.timestamp / 1 days);
    }
}
