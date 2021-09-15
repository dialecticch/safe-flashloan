// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Interfaces/FlashloanReceiver.sol";
import "./LoanModule.sol";

/// @title FlashloanModule
/// @dev A simple Module allowing anyone to execute Flashloans using the safe.
/// @author Dialectic
contract FlashloanModule is LoanModule {
    string public override NAME = "Flashloan Module";
    string public override VERSION = "1.0.0";

    /// The fees for a given safe.
    mapping(address => uint256) public fee;

    /// @dev Sets the fee for the sender.
    /// @param _fee The new fee.
    function setFee(uint256 _fee) external {
        fee[msg.sender] = _fee;
    }

    function execute(
        GnosisSafe safe,
        address[] calldata assets,
        uint256[] calldata amounts,
        address to,
        bytes calldata data
    ) external override {
        require(amounts.length == assets.length, "Length does not match");

        uint256[] memory outputs = new uint256[](amounts.length);

        uint256 safeFee = fee[address(safe)];

        for (uint256 i = 0; i < assets.length; i++) {
            transfer(safe, msg.sender, assets[i], amounts[i]);
            outputs[i] = (amounts[i] * safeFee) / 10000;
        }

        FlashloanReceiver(to).flash(safe, assets, amounts, outputs, data);

        for (uint256 i = 0; i < assets.length; i++) {
            transferFrom(safe, msg.sender, assets[i], outputs[i]);
        }
    }
}
