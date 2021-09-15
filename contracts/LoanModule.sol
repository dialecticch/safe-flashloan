pragma solidity ^0.8.4;

import "./Interfaces/GnosisSafe.sol";

abstract contract LoanModule {
    function execute(
        GnosisSafe safe,
        address[] calldata assets,
        uint256[] calldata amounts,
        address to,
        bytes calldata data
    ) external;

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
