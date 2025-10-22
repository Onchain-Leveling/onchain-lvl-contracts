// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/// @notice Custom errors for gas-efficient and standardized revert messages.
error AlreadyRegistered();
error NotRegistered();
error InvalidCharacter();
error TaskNotFound();
error TaskDisabled();
error ProgressZero();
error TaskAlreadyCompleted();
error Unauthorized();
