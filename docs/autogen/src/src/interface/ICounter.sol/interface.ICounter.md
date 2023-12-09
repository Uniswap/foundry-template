# ICounter
[Git Source](https://github.com/gretzke/foundry-template/blob/952489c408f511dc764c05d3a2a21ded78da224f/src/interface/ICounter.sol)

**Inherits:**
[IVersioned](/src/interface/IVersioned.sol/interface.IVersioned.md)


## Functions
### number


```solidity
function number() external view returns (uint256);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`uint256`|The current number|


### setNumber

Sets the number


```solidity
function setNumber(uint256 newNumber) external;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`newNumber`|`uint256`|The new number|


### increment

Increments the number by 1


```solidity
function increment() external;
```

