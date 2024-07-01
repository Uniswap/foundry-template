// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import "forge-std/Test.sol";
import "test/util/TestHelpers.sol";
import {GasSnapshot} from "forge-gas-snapshot/GasSnapshot.sol";

import {Counter} from "src/Counter.sol";

abstract contract Deployed is Test, TestHelpers {
    Counter counter;

    function setUp() public virtual {
        uint256 initialNumber = 10;
        counter = new Counter(initialNumber);
    }
}

contract CounterTest_Deployed is Deployed, GasSnapshot {
    function test_IsInitialized() public view {
        assertEq(counter.number(), 10);
    }

    function test_IncrementsNumber() public {
        counter.increment();
        snapLastCall("Increment counter number");
        assertEq(counter.number(), 11);
    }

    function testFuzz_SetsNumber(uint256 x) public {
        counter.setNumber(x);
        snapLastCall("Set counter number");
        assertEq(counter.number(), x);
    }
}
