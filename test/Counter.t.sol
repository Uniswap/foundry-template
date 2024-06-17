// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import "forge-std/Test.sol";
import "test/util/TestHelpers.sol";

import "script/deployers/CounterDeployer.s.sol";

abstract contract BeforeScript is Test, TestHelpers, CounterDeployer {
    function setUp() public virtual {
        counter = Counter(deployCounterImplementation());
    }
}

contract CounterTest_Zero is BeforeScript {
    function test_InitialState() public {
        assertEq(counter.number(), 0);
    }

    function test_RevertsOnInitialization(uint256 number) public {
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        counter.initialize(number);
    }
}

abstract contract AfterScript is Test, TestHelpers, CounterDeployer {
    function setUp() public virtual {
        address proxyAdmin = makeAddr("alice");
        uint256 initialNumber = 10;
        deployCounterTransparent(proxyAdmin, initialNumber);
    }
}

contract CounterTest_Initialized is AfterScript {
    function test_IsInitialized() public {
        assertEq(counter.number(), 10);
    }

    function test_RevertsIf_InitializedAgain() public {
        vm.expectRevert(Initializable.InvalidInitialization.selector);
        counter.initialize(1);
    }

    function test_IncrementsNumber() public {
        counter.increment();
        assertEq(counter.number(), 11);
    }

    function testFuzz_SetsNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }

    function test_ReturnsVersion() public {
        assertEq(counter.version(), "1.0.0");
    }
}
