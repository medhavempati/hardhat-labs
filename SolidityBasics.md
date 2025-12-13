## Variable Types

State: 
Written and stored on blockchain permanently. 
Persists between functions. 
Expensive to modify, cheap to read. 
Can only be declared in a contract outside of a function. State variables cannot be declared/created from within a function.

Local: 
Written and stored only temporarily within a function call. 
Doesn’t persist after function is done. 
Does not require additional gas because it doesn’t persist on chain. 
Used for intermediary calculations.

Global:
Built-in system information variables provided by ethereum.
You can’t define global variables like in other languages because Solidity does not have a file level or project level variable scope, variables only live within a contract or within a function.
Can simulate global variables by using a public state variable (this can be read by other contracts, would have to be modified through a modification function)

All global variables exist only during runtime, not stored in contract storage. 
So cannot be declared within the contract, only called/used in functions, as they do not exist between calls.

## Variable/Function Visibility Types

**Public**: Visible external and internal to the contract. Creates a getter function by default that allows retrieval of the data.

Public variables automatically generate a getter function that allows for a public variable to be seen externally, but not modified (no setter by default)

By default, for public functions that take inputs, the inputs are copied into memory (regardless of the input type, that is, calldata inputs or memory inputs). This copy function is more expensive than a read-only calldata (which is why external functions are  cheaper than public)

When public functions are called internally, calldata inputs are still copied into memory and can be modified. 
When public functions are called externally, calldata inputs remain calldata and cannot be modified.

*Default visibility for functions.*

**Private**: Only visible/can be called from within current contract, not accessible through child contracts.

**External**: Only can be called by external contracts. To call from within the same contract, it must still make an “external call” as such: this.foo()

Use external when you want to enforce modularity, when input parameters are large and want to save on gas, when the function is designed for external callers only.

Input parameters in external functions remain in the calldata space. They are not copied into memory.

**Internal**: Only can be called from within the contract. And can also be called from child contracts through inheritance.

*Default visibility for state variables.*

| Use Case | Best Visibility |
| --- | --- |
| Called by users / DApps | **external** |
| Called by other contracts | **external** |
| Called only internally or by derived contracts | **internal** |
| Called only by the same contract | **private** |

NOTE: Miscellaneous

- Visibility applies ONLY to state variables and functions, not local variables.
- Contracts do not have any general purpose write functions, on chain data cannot be modified arbitrarily. 
The ONLY way to write to or modify on chain data is to explicitly design a function in the contract to do so.
- Making an external call is more expensive that an internal call. Ex: this.foo() > foo().
- All variables and functions are visible publicly by inspecting the chain. public/private/internal/external determine the following:
    - Internal/external call permissions in terms of contracts.
    - Gas cost
    - Whether solidity creates a getter (for variables)
- Public functions are more flexible. Cheaper to call internally, more expensive to call externally. 
External functions are more restricted. Cheaper to call externally, more expensive to call internally.
- If you need a function to be both internally and externally accessible, prefer public, or split into internal + external wrapper.

## Solidity Data Types

Value Type | Reference Type | Special Type

Note: 

- All state variables default to the 0 value.
- Value type local variables must also be assigned (do not default to 0) upon initialization.
- Reference type local variables must be assigned a value. 
If storage, must reference and existing storage location
If memory, must be assigned a value at declaration
- Reference type input parameters must specify memory or calldata.

Boolean:
True or false value
Default initialization: false

Integer:
Uint8, Uint 16… Uint256 —> Unsigned integer (only positive) | Default = 0 
Will error out if it gets assigned a negative number.
Int8, Int16… Int256 —> Signed integer (positive or negative) | Default = 0

Address:
20-byte ethereum address
Default: 0x0000..00
If you declare a payable address variable —> Example: address payable wallet;
Special methods: wallet.transfer(1 ether), wallet.send(1 ether) [the contract is sending/transferring to the address payable]

Byte:
byte1, byte2, … byte32 —> Fixed byte
bytes —> Dynamic byte (up till 32 bytes), behaves like an array
Have the same special methods as an array: push, pop, length

String:
self explanatory

Enum:
User defined limited set of constant values
Example: enum Status { Pending, Active, Closed }
Can be referenced as: Status test; test = Status.Closed;

Struct:
Custom data container.

Array:
Can be fixed (uint256[3]) or dynamic (uint256[])
Special methods: 
uint256[] test;
test.push(10) —> Adds input value at the end of the array
test.pop() —> Removes the last added value of the array
test.length —> Returns the length of the array

Mapping:
Hash table, key-value store.
Example: mapping(address ⇒ uint256) public balances;
Default: initializes to the default values of the respective value types.

Tuple:
No explicit ‘Tuple’ type, only implicitly declared 
Group of values, can be used to return multiple values from a function.
Only a tuple and a struct can be used to return multiple values from a function.
Example: (int256 x, bool y)

## Function Types

Two types of functions that dont have to spend gas: view, pure

View Function: Just reading state of the contract. Disallow any modification of state.
Calling a view function is free unless its called from inside another function that costs gas.

Pure Function: Disallow reading or modification of state. Can just be used to perform some in place operations and return results.

## Storage Location Keywords

These keywords only apply to reference types

**Memory**:
Used with function parameters and temp vars. Temporary storage, erased after call.

function getCopy(uint256 index) public view returns (Person memory) {
Person memory copy = people[index]; // copy of data
copy.favoriteNumber = 999;          // modifies only local copy
return copy;                        // returns in memory
}

**Storage**:
Implied for state variables. Persistent on chain.

Storage MEANS referencing a pointer to a particular location in the contracts permanent data storage. This keyword cannot be used to declare a new variable/data value. 
Can only be used to reference an existing state variable from within a function.

This is why input parameters cannot be storage variables. As input parameters/data cannot reference an existing on chain data space. 
Input parameters must be memory or calldata.

struct Person {
uint256 favoriteNumber;
string name;
}

Person[] public people; // storage by default

function update(uint256 index, uint256 newNumber) public {
Person storage p = people[index]; // p is a reference into storage
p.favoriteNumber = newNumber;     // writes to blockchain
}

**Calldata**: 
External function parameters. Read only, no modifications allowed, so cheapest option for big inputs.

| Function Type | Reference-Type Parameters | Default |
| --- | --- | --- |
| **external** | string, bytes, arrays, structs | ❗ **No default → must specify** (`calldata` required) |
| **public** | reference types | **memory** |
| **internal** | reference types | **memory** |
| **private** | reference types | **memory** |
| **value types** | (uint, bool, address, etc.) | Always stack (no data location) |

NOTE: There are three other places that data can be stored in EVM:

1. Stack
2. Code
3. Logs

| Component | Persistence | Location |
| --- | --- | --- |
| Storage | permanent | blockchain state |
| Memory | temporary | RAM-like memory of EVM instance |
| Stack | temporary | CPU-like register stack |
| Calldata | temporary | input buffer to EVM |
| Code | permanent | code storage section |
| Logs | permanent | tx receipt area (NOT accessible to contracts) |

Note:

- EVM must allocate memory**,** must copy data from calldata into memory
Memory expansion costs grow quadratically
- For Calldata: No copying, no allocation, read-only, so EVM doesn't need to track mutations
- Storage is NOT copied, storage variables are references.

## Constructors

Functions that run once at deployment, never called again afterwards.
Typically used to initialize variables.
Constructor code is thrown away after running, its not stored on-chain.

constructor(uint256 initialValue, string memory name) {
count = initialValue;
contractName = name;
owner = msg.sender;
}

## Modifiers

Reusable wrappers for functions.
Typically used for access control.
_; —> syntax for execute wrapped function here.
Can run logic before and after the function.
Can stack multiple modifiers onto a function.

modifier logTime() {
uint256 start = block.timestamp;
_;
uint256 end = block.timestamp;
}

constructor() {
owner = msg.sender;  // deployer becomes the owner
}

modifier onlyOwner() {
    require(msg.sender == owner, "Not owner");
    _;
}

function withdraw() public onlyOwner nonReentrant {}