# Beginner Hardhat 3 Tutorial

### Installation & Setup
npm init -y                                                     // Initialize a new node.js project
npm install --save-dev hardhat                                  // Install hardhat and development dependencies
npm install --save-dev @nomicfoundation/hardhat-toolbox         // Install hardhat toolbox
npm install --save-dev hardhat-ethers ethers                    // Install ethers + Hardhat ethers adapter
npm install --save-dev typescript ts-node                       // Install typescript + runtime
npx hardhat                                                     // Initializes and generates the project structure

(OR)

npm init -y && npm install --save-dev hardhat @nomicfoundation/hardhat-toolbox hardhat-ethers ethers typescript ts-node

### Files & Requirements
Typical File Structure:
artifacts:
This is where the build output metadata is stored.
Safe to delete | Auto-generated | Do not need to commit to git

cache:
Compilation and deployment cache to make recompilation faster.
Safe to delete | Auto-generated | Do not need to commit it git

contracts:
This is where your solidity contracts are held. Each .sol file can define one or more smart contracts.
Example: YourContract.sol

ignition:
This is Hardhat 3's deployment system.

    deployments:
    Deployed addresses, deployment state etc. is stored here. 
    Safe to delete | Auto-generated | DO NOT commit (may contain sensitive data)

    modules:
    Deployment scripts are defined here.
    There should be a .ts file for every .sol file.
    The .ts file defines how a contract should be deployed (constructor parameters, dependencies etc.)
    Example: YourContractModule.ts

.gitignore:
This is where you should specify every file and folder that you want to always exclude from git commits.

hardhat.config.ts:
This is the main configuration file for Hardhat.
Contains: Solidity version, network configurations, plugins, environment variables, etc.
Not Auto-generated/Configurable | Should commit

package-lock.json:
Snapshot of the exact dependencies.
Auto-generated | Should commit

package.json:
This defines the project's name, dependencies and command line shortcut scripts.

### Main Files to work on
1. Solidity File (contract/YourContract.sol)
    Contains state variables, constructor, contract logic, functions(used to interact with the contract), events, etc.

2. Deployment Module (ignition/modules/YourContractModule.ts)
    This file tells Ignition of deployment instructions and input parameters (if any) requirements.

3. Hardhat Config (hardhat.config.ts)
    This is the main configuration for Hardhat and contains the solidity version, network configurations, plugins, environment variables, etc.

### Deployment to Local Network
Command: npx hardhat compile
    Expected result:
    Hardhat shows which contracts were compiled
    This produces the /artifacts and /cache folders

[In a separate terminal session] Run local simulated network
Command: npx hardhat node 
    Expected result:
    Lists 20 auto-generated (fake)addresses and their private keys
    The local blockchain runs at http://127.0.0.1:8545

[Back in original terminal session] 
Deploy the contract
Command: npx hardhat ignition deploy ./ignition/modules/YourContractModule.ts --network localhost
    Expected result: Deploys your contract and displays the address of the contract (yourContractAddress)

Run the console
Command: npx hardhat console --network localhost 

Import hardhat ethers:
    > const { network } = await import("hardhat");
    > const { ethers } = await network.connect();

Connect to the deployed contract:    
    > const contractVariable = await ethers.getContractAt("YourContract", "[yourContractAddress]");

### Interact with Contract through console
Read operations

Write operations

## Simple Storage Contract

