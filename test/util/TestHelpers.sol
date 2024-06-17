// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import "forge-std/Test.sol";

abstract contract TestHelpers is Test {
    Account internal DEPLOYER;

    constructor() {
        DEPLOYER = makeAccount("DEPLOYER");
        vm.setEnv("PRIVATE_KEY", vm.toString(DEPLOYER.key));
    }
}
