// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.23;

interface IVersioned {
    /// @return The version of the contract
    function version() external pure returns (string memory);
}
