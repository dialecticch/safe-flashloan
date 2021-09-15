// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./GnosisSafe.sol";

/// @title FlashloanReceiver
/// @dev A simple contract that can executes a Flashloan strategy with funds from a safe.
/// @author Dialectic
interface FlashloanReceiver {
    /// @dev Function to execute with borrowed assets.
    /// @param from The safe providing the assets.
    /// @param assets The assets lent.
    /// @param amounts The amounts lent.
    /// @param back The amounts expected back.
    /// @param data The data passed on.
    function flash(
        GnosisSafe from,
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata back,
        bytes calldata data
    ) external;
}
