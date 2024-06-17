// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

import {ICounter, IVersioned} from "./interface/ICounter.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract Counter is ICounter, Initializable {
    uint256 public number;

    constructor() {
        _disableInitializers();
    }

    function initialize(uint256 initialNumber) public initializer {
        number = initialNumber;
    }

    /// @inheritdoc ICounter
    function setNumber(uint256 newNumber) public {
        number = newNumber;
    }

    /// @inheritdoc ICounter
    function increment() public {
        number++;
    }

    /// @inheritdoc IVersioned
    function version() external pure returns (string memory) {
        return "1.0.0";
    }
}
