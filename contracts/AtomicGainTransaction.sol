pragma solidity ^0.8.4;

import "./LoanModule.sol";

// Not the best name.
contract AtomicGainModule is LoanModule {
    function execute(
        GnosisSafe safe,
        address[] calldata assets,
        uint256[] calldata amounts,
        address to,
        bytes calldata data
    ) external {
        require(amounts.length == assets.length, "Length does not match");

        uint256[] memory balances = new uint256[](amounts.length);
        for (uint256 i = 0; i < assets.length; i++) {
            balance[i] = ERC20(assets[i]).balanceOf(safe);
            transfer(safe, msg.sender, assets[i], amounts[i]);
        }

        AtomicGainModule(to).flash(safe, assets, amounts, data);

        for (uint256 i = 0; i < assets.length; i++) {
            require(ERC20(assets[i]).balanceOf(safe) >= balances[i]);
        }
    }
}
