// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./GnosisSafe.sol";

interface Receiver {
    function flash(
        GnosisSafe from,
        address[] calldata asset,
        uint256[] calldata amounts,
        uint256[] calldata back,
        bytes calldata data
    ) external;
}
