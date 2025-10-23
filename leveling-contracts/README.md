# Foundry Smart Contract Development Toolkit

![Foundry](https://img.shields.io/badge/Foundry-1.0.0-blue)
![Solidity](https://img.shields.io/badge/Solidity-^0.8.0-green)
![Base](https://img.shields.io/badge/Network-Base%20Sepolia-orange)

## Overview

**Foundry** is a high-performance, portable, and modular toolkit for Ethereum application development written in Rust. Designed for modern smart contract development, it offers unparalleled speed and efficiency compared to traditional JavaScript-based tools.

## Toolkit Components

- **Forge**: Advanced Ethereum testing framework and development environment
- **Cast**: Comprehensive CLI tool for EVM interactions, transactions, and chain data
- **Anvil**: Local Ethereum node implementation for development and testing
- **Chisel**: Interactive Solidity REPL for rapid prototyping and debugging

## Production Deployment

**Contract Address**: `0x90101bdcbAc8e0046Bc3b1b24A3286560B9C9D15`  
**Network**: Base Sepolia Testnet  
**Block Explorer**: [View on Basescan](https://sepolia.basescan.org/address/0x90101bdcbAc8e0046Bc3b1b24A3286560B9C9D15)

## Documentation

Comprehensive documentation and tutorials available at:  
[https://book.getfoundry.sh/](https://book.getfoundry.sh/)

## Quick Start

### Prerequisites

- Rust 1.67.0 or later
- Git

### Installation

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

## Development Workflow

### Build Project
```shell
$ forge build
```

### Run Test Suite
```shell
$ forge test
```

### Code Formatting
```shell
$ forge fmt
```

### Gas Optimization Analysis
```shell
$ forge snapshot
```

### Local Development Network
```shell
$ anvil
```

### Production Deployment
```shell
$ forge script script/Counter.s.sol:CounterScript \
  --rpc-url <your_rpc_url> \
  --private-key <your_private_key> \
  --broadcast \
  --verify \
  --etherscan-api-key <your_etherscan_key>
```

### Contract Interaction Examples
```shell
# Read contract data
$ cast call <contract_address> "functionName()"

# Send transactions
$ cast send <contract_address> "functionName(param)" \
  --rpc-url <rpc_url> \
  --private-key <private_key>
```

## Project Structure

```
├── script/           # Deployment scripts
├── src/             # Smart contract source code
├── test/            # Test files
├── lib/             # Dependencies
└── out/             # Build artifacts
```

## Verification

Verify your deployed contract on BaseScan:

```shell
$ forge verify-contract \
  --chain-id 84532 \
  --etherscan-api-key <api_key> \
  0x90101bdcbAc8e0046Bc3b1b24A3286560B9C9D15 \
  src/Contract.sol:ContractName
```

## Network Configuration

### Base Seplia RPC Endpoints
- Alchemy: `https://base-sepolia.g.alchemy.com/v2/your-api-key`
- Public: `https://sepolia.base.org`

## Common Commands

### Get Help
```shell
$ forge --help
$ anvil --help
$ cast --help
```

### Dependency Management
```shell
# Install dependencies
$ forge install

# Update dependencies
$ forge update
```

## License

This project is licensed under the MIT License.

---

**Ready to build?** Check out the [Foundry Book](https://book.getfoundry.sh/) for detailed guides and examples.
