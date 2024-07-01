// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import "forge-std/Test.sol";
import "test/util/TestHelpers.sol";

import {Counter} from "src/Counter.sol";

abstract contract Deployed is Test, TestHelpers {
    Counter counter;

    function setUp() public virtual {
        uint256 initialNumber = 10;
        counter = new Counter(initialNumber);
    }
}

contract CounterTest_Deployed is Deployed {
    function test_IsInitialized() public {
        assertEq(counter.number(), 10);
    }

    function test_IncrementsNumber() public {
        counter.increment();
        assertEq(counter.number(), 11);
    }

    function testFuzz_SetsNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }
}
