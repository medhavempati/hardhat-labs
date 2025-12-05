# Beginner Hardhat 3 Tutorial

### Installation & Setup

### Files & Requirements
Explain in one line each of the following folders:
artifacts
cache
contracts
ignition
    deployments
    modules
hardhat.config.ts
package-lock.json
package.json
tsconfig.json

Main Files to work on
1. Each .sol file in contracts defines one contract.
2. For each contract file, there should be a corresponding .ts file in ignition/modules.
    What are the main contents of the .sol file and what are the main contents of the corresponding .ts file.
3. what is necessary in the hardhat.config.ts.

#### Deployment to Local Network
npx hardhat compile
    Expected result:
    1-2 lines of explanation of the results:

[In a separate terminal session] Run local simulated network
npx hardhat node 

[Back in original terminal session] 

Deploy the contract
npx hardhat ignition deploy ./ignition/modules/[contractFileName].ts --network localhost
    Expected result: you will get the address of the contract

Run the console (Interact with the contract through console)
npx hardhat console --network localhost 

    > const { network } = await import("hardhat");
    > const { ethers } = await network.connect();
    > const contractVariable = await ethers.getContractAt("contractName", "[contractAddress]");


## Simple Storage Contract

