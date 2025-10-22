// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Ownable} from "@openzeppelin-contracts/contracts/access/Ownable.sol";
import "./core/CharacterManager.sol";
import "./core/LevelManager.sol";
import "./core/TaskManager.sol";
import "./interfaces/ICharacterManager.sol";
import "./interfaces/ILevelManager.sol";
import "./interfaces/ITaskManager.sol";

/// @title OnchainLeveling
/// @notice Main entrypoint aggregating registration, tasks, and XP/level logic for the MVP.
/// @dev Single-contract deployment via multiple inheritance; future modules can be added modularly.
contract OnchainLeveling is
    Ownable,
    CharacterManager,
    LevelManager,
    TaskManager
{
    constructor(address initialOwner) Ownable(initialOwner) {
        // Seed default demo tasks (ids start from 1)
        _createTaskDef("Running", uint8(TaskType.Running), 1, 100, true);  // goal: 1 (km)
        _createTaskDef("Walking", uint8(TaskType.Walking), 5, 100, true);  // goal: 5 (km)
        _createTaskDef("Sit-ups", uint8(TaskType.Situps), 10, 80, true);   // goal: 10 (reps)
    }

    // ---------- Character Manager ----------
    function register(string calldata name, uint8 characterType)
        public
        override(CharacterManager)
    {
        super.register(name, characterType);
    }

    function getProfile(address user)
        external
        view
        override(CharacterManager)
        returns (string memory, uint8, uint32, uint256, bool)
    {
        UserProfile storage u = _users[user];
        return (u.name, u.characterType, u.level, u.xp, u.registered);
    }

    // ---------- Admin: Task Templates ----------
    function createTaskDef(
        string calldata name,
        uint8 ttype,
        uint16 goal,
        uint16 xp,
        bool enabled
    ) external override onlyOwner returns (uint256) {
        return _createTaskDef(name, ttype, goal, xp, enabled);
    }

    function updateTaskDef(
        uint256 taskId,
        string calldata name,
        uint8 ttype,
        uint16 goal,
        uint16 xp,
        bool enabled
    ) external override onlyOwner {
        _updateTaskDef(taskId, name, ttype, goal, xp, enabled);
    }

    // ---------- User: Task Progress ----------
    function addProgress(uint256 taskId, uint16 amount) external override {
        _requireRegistered(msg.sender);
        _addProgress(msg.sender, taskId, amount);
    }

    function getTaskDef(uint256 taskId)
        external
        view
        override
        returns (string memory name, uint8 ttype, uint16 goal, uint16 xp, bool enabled)
    {
        TaskDef memory td = _getTaskDef(taskId);
        return (td.name, uint8(td.ttype), td.goal, td.xp, td.enabled);
    }

    function taskDefCount() external view override returns (uint256) {
        return _taskCount();
    }

    function getProgress(address user, uint32 day, uint256 taskId)
        external
        view
        override
        returns (uint16 progress, bool completed)
    {
        return _getProgress(user, day, taskId);
    }

    // ---------- Level Manager ----------
    function xpOf(address user) public view override(LevelManager) returns (uint256) {
        return super.xpOf(user);
    }

    function levelOf(address user) public view override(LevelManager) returns (uint32) {
        return super.levelOf(user);
    }

    function nextLevelXp(address user)
        external
        view
        override(LevelManager)
        returns (uint256 remaining, uint256 nextLevelCumulative)
    {
        if (!_users[user].registered) return (0, 0);
        uint32 lvl = _users[user].level;
        uint256 nextCum = XPUtils.cumulativeXpForLevel(lvl + 1);
        uint256 currentXp = _users[user].xp;
        uint256 xpRemaining = nextCum > currentXp ? (nextCum - currentXp) : 0;
        return (xpRemaining, nextCum);
    }

    // ---------- Internal Wiring ----------
    function _awardXp(address user, uint256 amount)
        internal
        override(TaskManager, LevelManager)
    {
        super._awardXp(user, amount);
    }

    function _requireRegistered(address user)
        internal
        view
        override(LevelManager, CharacterManager)
    {
        super._requireRegistered(user);
    }

    // ---------- Frontend Helpers ----------
    /// @notice Paginates task definitions for lightweight UI fetches.
    function listTaskDefs(uint256 offset, uint256 limit)
        external
        view
        returns (
            uint256[] memory ids,
            string[] memory names,
            uint8[] memory ttypes,
            uint16[] memory goals,
            uint16[] memory xps,
            bool[] memory enableds
        )
    {
        uint256 total = _taskDefCount;
        if (offset >= total) {
            return (
                new uint256[](0),
                new string[](0),
                new uint8[](0),
                new uint16[](0),
                new uint16[](0),
                new bool[](0)
            );
        }
        uint256 end = offset + limit;
        if (end > total) end = total;
        uint256 n = end - offset;

        ids = new uint256[](n);
        names = new string[](n);
        ttypes = new uint8[](n);
        goals = new uint16[](n);
        xps = new uint16[](n);
        enableds = new bool[](n);

        for (uint256 i = 0; i < n; i++) {
            uint256 id = offset + 1 + i;
            TaskDef storage td = _taskDefs[id];
            ids[i] = id;
            names[i] = td.name;
            ttypes[i] = uint8(td.ttype);
            goals[i] = td.goal;
            xps[i] = td.xp;
            enableds[i] = td.enabled;
        }
    }

    /// @notice Returns today's progress for all task definitions for a given user.
    function todayAllProgress(address user)
        external
        view
        returns (
            uint32 day,
            uint16[] memory progresses,
            bool[] memory completeds
        )
    {
        day = _today();
        uint256 n = _taskDefCount;

        progresses = new uint16[](n);
        completeds = new bool[](n);

        for (uint256 i = 0; i < n; i++) {
            (uint16 p, bool c) = _getProgress(user, day, i + 1);
            progresses[i] = p;
            completeds[i] = c;
        }
    }
}
