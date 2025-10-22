// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "../storage/TaskStorage.sol";
import "../utils/Errors.sol";

/// @title TaskManager
/// @notice Handles creation, updating, and completion of tasks.
abstract contract TaskManager is TaskStorage {
    event TaskDefCreated(uint256 indexed taskId, string name);
    event TaskDefUpdated(uint256 indexed taskId);
    event TaskProgressed(address indexed user, uint32 day, uint256 indexed taskId, uint16 oldProgress, uint16 newProgress);
    event TaskCompleted(address indexed user, uint32 day, uint256 indexed taskId, uint16 progress, uint16 goal, uint256 xpAwarded);

    function _awardXp(address user, uint256 amount) internal virtual;

    // --- Admin: Template Management ---

    function _createTaskDef(string memory name, uint8 ttype, uint16 goal, uint16 xp, bool enabled)
        internal
        returns (uint256)
    {
        uint256 id = ++_taskDefCount;
        _taskDefs[id] = TaskDef(name, TaskType(ttype), goal, xp, enabled);
        emit TaskDefCreated(id, name);
        return id;
    }

    function _updateTaskDef(uint256 taskId, string memory name, uint8 ttype, uint16 goal, uint16 xp, bool enabled)
        internal
    {
        if (taskId == 0 || taskId > _taskDefCount) revert TaskNotFound();
        TaskDef storage td = _taskDefs[taskId];
        td.name = name;
        td.ttype = TaskType(ttype);
        td.goal = goal;
        td.xp = xp;
        td.enabled = enabled;
        emit TaskDefUpdated(taskId);
    }

    // --- User: Progress Management ---

    function _addProgress(address user, uint256 taskId, uint16 amount) internal {
        if (amount == 0) revert ProgressZero();
        if (taskId == 0 || taskId > _taskDefCount) revert TaskNotFound();

        TaskDef storage td = _taskDefs[taskId];
        if (!td.enabled) revert TaskDisabled();

        uint32 day = _today();
        UserTaskProgress storage p = _progress[user][day][taskId];
        if (p.completed) revert TaskAlreadyCompleted();

        uint16 oldP = p.progress;
        uint256 newP = uint256(oldP) + amount;
        if (newP > type(uint16).max) newP = type(uint16).max;

        p.progress = uint16(newP);
        emit TaskProgressed(user, day, taskId, oldP, p.progress);

        if (p.progress >= td.goal && !p.completed) {
            p.completed = true;
            _awardXp(user, td.xp);
            emit TaskCompleted(user, day, taskId, p.progress, td.goal, td.xp);
        }
    }

    function _getTaskDef(uint256 taskId) internal view returns (TaskDef memory) {
        if (taskId == 0 || taskId > _taskDefCount) revert TaskNotFound();
        return _taskDefs[taskId];
    }

    function _taskCount() internal view returns (uint256) {
        return _taskDefCount;
    }

    function _getProgress(address user, uint32 day, uint256 taskId)
        internal
        view
        returns (uint16 progress, bool completed)
    {
        UserTaskProgress storage p = _progress[user][day][taskId];
        return (p.progress, p.completed);
    }
}
