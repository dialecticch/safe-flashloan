//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Interfaces/GnosisSafe.sol";
import "./Interfaces/ERC20.sol";
import "./Interfaces/Receiver.sol";

contract FlashloanModule {
    function execute(
        GnosisSafe safe,
        address[] calldata assets,
        uint256[] calldata amounts,
        Receiver to,
        bytes calldata data
    ) external {
        require(amounts.length == assets.length, "Length does not match");

        uint256[] memory outputs = new uint256[](amounts.length);
        for (uint256 i = 0; i < assets.length; i++) {
            transfer(safe, msg.sender, assets[i], amounts[i]);
            outputs[i] = amounts[i]; // @TODO CALC FEE
        }

        to.flash(safe, assets, amounts, outputs, data);

        for (uint256 i = 0; i < assets.length; i++) {
            transferFrom(safe, msg.sender, assets[i], outputs[i]);
        }
    }

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
