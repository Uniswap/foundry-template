# Contributing

For the latest version of this document, see [here](https://github.com/Uniswap/foundry-template/blob/main/CONTRIBUTING.md).

- [Install](#install)
- [Pre-commit Hooks](#pre-commit-hooks)
- [Requirements for merge](#requirements-for-merge)
- [Code Practices](#code-practices)
  - [Code Style](#code-style)
  - [Solidity Versioning](#solidity-versioning)
  - [Interfaces](#interfaces)
  - [NatSpec \& Comments](#natspec--comments)
- [Testing](#testing)
  - [Best Practices](#best-practices)
  - [IR Compilation](#ir-compilation)
  - [Gas Metering](#gas-metering)
- [Deployment](#deployment)
  - [Deployment](#deployment-1)
  - [Deployment Info Generation](#deployment-info-generation)
- [Releases](#releases)

## Install

Follow these steps to set up your local environment for development:

- [Install foundry](https://book.getfoundry.sh/getting-started/installation)
- Install dependencies: `forge install`
- [Install pre-commit](https://pre-commit.com/#installation)
- Install pre commit hooks: `pre-commit install`

## Pre-commit Hooks

Follow the [installation steps](#install) to enable pre-commit hooks. To ensure consistency in our formatting `pre-commit` is used to check whether code was formatted properly and the documentation is up to date. Whenever a commit does not meet the checks implemented by pre-commit, the commit will fail and the pre-commit checks will modify the files to make the commits pass. Include these changes in your commit for the next commit attempt to succeed. On pull requests the CI checks whether all pre-commit hooks were run correctly.
This repo includes the following pre-commit hooks that are defined in the `.pre-commit-config.yaml`:

- `mixed-line-ending`: This hook ensures that all files have the same line endings (LF).
- `format`: This hook uses `forge fmt` to format all Solidity files.
- `doc`: This hook uses `forge doc` to automatically generate documentation for all Solidity files whenever the NatSpec documentation changes. The `script/util/doc_gen.sh` script is used to generate documentation. Forge updates the commit hash in the documentation automatically. To only generate new documentation when the documentation has actually changed, the script checks whether more than just the hash has changed in the documentation and discard all changes if only the hash has changed.
- `prettier`: All remaining files are formatted using prettier.

## Requirements for merge

In order for a PR to be merged, it must pass the following requirements:

- All commits within the PR must be signed
- CI must pass (tests, linting, etc.)
- New features must be merged with associated tests
- Bug fixes must have a corresponding test that fails without the fix
- The PR must be approved by at least one maintainer
  - The PR must be approved by 2+ maintainers if the PR is a new feature or > 100 LOC changed
- The PR must be squash merged into a single commit

## Code Practices

### Code Style

The repo follows the official [Solidity Style Guide](https://docs.soliditylang.org/en/latest/style-guide.html). In addition to that, this repo also borrows the following rules from [OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/GUIDELINES.md#solidity-conventions):

- Internal or private state variables or functions should have an underscore prefix.

  ```solidity
  contract TestContract {
      uint256 private _privateVar;
      uint256 internal _internalVar;
      function _testInternal() internal { ... }
      function _testPrivate() private { ... }
  }
  ```

- Naming collisions should be avoided using a single trailing underscore.

  ```solidity
  contract TestContract {
      uint256 public foo;

      constructor(uint256 foo_) {
        foo = foo_;
      }
  }
  ```

- Events should generally be emitted immediately after the state change that they
  represent, and should be named in the past tense. Some exceptions may be made for gas
  efficiency if the result doesn't affect observable ordering of events.

  ```solidity
  function _burn(address who, uint256 value) internal {
      super._burn(who, value);
      emit TokensBurned(who, value);
  }
  ```

- Interface names should have a capital I prefix.

  ```solidity
  interface IERC777 {
  ```

- Contracts not intended to be used standalone should be marked abstract
  so they are required to be inherited to other contracts.

  ```solidity
  abstract contract AccessControl is ..., {
  ```

- Unchecked arithmetic blocks should contain comments explaining why overflow is guaranteed not to happen or permissible. If the reason is immediately apparent from the line above the unchecked block, the comment may be omitted.

### Solidity Versioning

Contracts that are meant to be deployed MUST have an explicit version set in the `pragma` statement.

```solidity
pragma solidity 0.8.X;
```

Abstract contracts, libraries and interfaces MUST use the caret (`^`) range operator to specify the version range to ensure better compatibility.

```solidity
pragma solidity ^0.X.0;
```

Libraries and abstract contracts using functionality introduced in newer versions of Solidity can use caret range operators with higher path versions (e.g., `^0.8.24` when using transient storage opcodes). For interfaces, it should be considered to use the greater than or equal to (`>=`) range operator to ensure better compatibility with future versions of Solidity.

### Interfaces

Every contract MUST implement their corresponding interface that includes all externally callable functions, errors and events.

### NatSpec & Comments

Interfaces should be the entrypoint for all contracts. When exploring the a contract within the repository, the interface MUST contain all relevant information to understand the functionality of the contract in the form of NatSpec comments. This includes all externally callable functions, errors and events. The NatSpec documentation MUST be added to the functions, errors and events within the interface. This allows a reader to understand the functionality of a function before moving on to the implementation. The implementing functions MUST point to the NatSpec documentation in the interface using `@inheritdoc`. Internal and private functions shouldn't have NatSpec documentation except for `@dev` comments, whenever more context is needed. Additional comments within a function should only be used to give more context to more complex operations, otherwise the code should be kept readable and self-explanatory. NatSpec comments should be written with a triple slash (`///`) to ensure compact documentation.

## Testing

The following testing practices should be followed when writing unit tests for new code. All functions, lines and branches should be tested to result in 100% testing coverage. Fuzz parameters and conditions whenever possible. Extremes should be tested in dedicated edge case and corner case tests. Invariants should be tested in dedicated invariant tests.

Differential testing should be used to compare assembly implementations with implementations in Solidity or testing alternative implementations against existing Solidity or non-Solidity code using ffi.

New features must be merged with associated tests. Bug fixes should have a corresponding test that fails without the bug fix.

### Best Practices

Best practices and naming conventions should be followed as outlined in the [Foundry Book](https://getfoundry.sh/forge/tests/overview).

### IR Compilation

When the contracts are compiled via IR, tests should be compiled without IR and the contracts deployed from their bytecode to ensure quick compilation times and bytecode consistency. Check [here](https://github.com/Uniswap/foundry-template/blob/613f81c107cd2885a869dbe4afc1da4f96ed9218/foundry.toml#L22-L28) and [here](https://github.com/Uniswap/foundry-template/blob/main/test/deployers/CounterDeployer.sol) for an example.

### Gas Metering

The [Forge Gas Snapshot](https://github.com/marktoda/forge-gas-snapshot) library is used to measure the gas cost of individual actions. Tests that measure gas should be annotated with `/// forge-config: default.isolate = true` and not be fuzzed to ensure that the gas snapshot is accurate and consistent for CI verification. All external functions should have a gas snapshot test, diverging paths within a function should have appropriate gas snapshot tests.

## Deployment

After deployments are executed a script is provided that extracts deployment information from the `run-latest.json` file within the `broadcast` directory generated while the forge script runs. From this information a JSON and markdown file is generated using the [Forge Chronicles](https://github.com/0xPolygon/forge-chronicles) library containing various information about the deployment itself as well as past deployments.

### Deployment

To deploy the contracts, provide the `--broadcast` flag to the forge script command. Should the etherscan verification time out, it can be picked up again by replacing the `--broadcast` flag with `--resume`.
Deploy the contracts to one of the predefined networks by providing the according key with the `--rpc-url` flag. Most of the predefined networks require the `INFURA_KEY` environment variable to be set in the `.env` file.
Including the `--verify` flag will verify deployed contracts on Etherscan. Define the appropriate environment variable for the Etherscan api key in the `.env` file.

```shell
forge script script/Deploy.s.sol --broadcast --rpc-url <rpc_url> --verify
```
