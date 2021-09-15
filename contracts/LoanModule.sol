// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Interfaces/GnosisSafe.sol";
import "./Interfaces/ERC20.sol";

/// @title LoanModule
/// @author Dialectic
abstract contract LoanModule {
    /// @dev Executes an "atomic loan" transaction.
    /// @param safe The safe providing the assets.
    /// @param assets The assets to borrow.
    /// @param amounts The amounts to borrow.
    /// @param to The receiver of the atomic loan.
    /// @param data The data passed on to the receiver.
    function execute(
        GnosisSafe safe,
        address[] calldata assets,
        uint256[] calldata amounts,
        address to,
        bytes calldata data
    ) external virtual;

    function transfer(
        GnosisSafe safe,
        address to,
        address asset,
        uint256 amount
    ) internal {
        bool success = safe.execTransactionFromModule(
            asset,
            0,
            abi.encodeWithSelector(ERC20.transfer.selector, to, amount),
            GnosisSafe.Operation.CALL
        );

        require(success, "failed to transfer");
    }

    function transferFrom(
        GnosisSafe safe,
        address from,
        address asset,
        uint256 amount
    ) internal {
        bool success = safe.execTransactionFromModule(
            asset,
            0,
            abi.encodeWithSelector(
                ERC20.transferFrom.selector,
                from,
                address(safe),
                amount
            ),
            GnosisSafe.Operation.CALL
        );

        require(success, "failed to transfer");
    }
}
