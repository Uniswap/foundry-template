// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.26;

import 'forge-std/Test.sol';

import {CounterDeployer, ICounter} from './deployers/CounterDeployer.sol';
import {Deploy} from 'script/Deploy.s.sol';

abstract contract Deployed is CounterDeployer {
    ICounter counter;

    function setUp() public virtual {
        uint256 initialNumber = 10;
        counter = deploy(initialNumber);
    }
}

contract CounterTest_Deployed is Deployed {
    function test_IsInitialized() public view {
        assertEq(counter.number(), 10);
    }

    /// forge-config: default.isolate = true
    function test_IncrementsNumber() public {
        counter.increment();
        vm.snapshotGasLastCall('Increment counter number');
        assertEq(counter.number(), 11);
    }

    function test_fuzz_SetsNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }

    /// forge-config: default.isolate = true
    function test_SetNumber_gas() public {
        uint256 x = 100;
        counter.setNumber(x);
        vm.snapshotGasLastCall('Set counter number');
    }
}

contract DeploymentTest is Test {
    ICounter counter;

    function setUp() public virtual {
        counter = new Deploy().run();
    }

    function test_IsDeployedCorrectly() public view {
        assertEq(counter.number(), 5);
    }
}
