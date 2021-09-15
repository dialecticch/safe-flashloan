// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./GnosisSafe.sol";

interface AtomicGainReceiver {
    function flash(
        GnosisSafe from,
        address[] calldata asset,
        uint256[] calldata amounts,
        bytes calldata data
    ) external;
}
