// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Interfaces/FlashloanReceiver.sol";
import "./LoanModule.sol";

/// @title FlashloanModule
/// @dev A simple Module allowing anyone to execute Flashloans using the safe.
/// @author Dialectic
contract FlashloanModule is LoanModule {
    function execute(
        GnosisSafe safe,
        address[] calldata assets,
        uint256[] calldata amounts,
        address to,
        bytes calldata data
    ) external override {
        require(amounts.length == assets.length, "Length does not match");

        uint256[] memory outputs = new uint256[](amounts.length);
        for (uint256 i = 0; i < assets.length; i++) {
            transfer(safe, msg.sender, assets[i], amounts[i]);
            outputs[i] = amounts[i]; // @TODO CALC FEE
        }

        FlashloanReceiver(to).flash(safe, assets, amounts, outputs, data);

        for (uint256 i = 0; i < assets.length; i++) {
            transferFrom(safe, msg.sender, assets[i], outputs[i]);
        }
    }
}
