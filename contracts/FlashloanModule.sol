//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Interfaces/GnosisSafe.sol";
import "./Interfaces/ERC20.sol";
import "./Interfaces/FlashloanReceiver.sol";
import "./LoanModule.sol";

contract FlashloanModule is LoanModule {
    function execute(
        GnosisSafe safe,
        address[] calldata assets,
        uint256[] calldata amounts,
        address to,
        bytes calldata data
    ) external {
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
