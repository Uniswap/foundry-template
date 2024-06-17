// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import "forge-std/Script.sol";
import "script/deployers/CounterDeployer.s.sol";

contract Deploy is Script, CounterDeployer {
    using stdJson for string;

    function run() public {
        address proxyAdmin = address(1);
        uint256 initialNumber = 5;
        deployCounterTransparent(proxyAdmin, initialNumber);
    }
}
