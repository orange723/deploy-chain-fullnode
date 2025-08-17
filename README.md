# deploy-chain-fullnode

This repository provides scripts and configurations to deploy full nodes for various Web3 chains using Docker.

## Chain Snapshots

Snapshots for some chains can be downloaded from [publicnode](https://www.publicnode.com/snapshots) to speed up the syncing process.

## Supported Chains

- Ethereum/Sepolia
- BNB/BNB Testnet
- Arbitrum One
- Linea
- Scroll

---

## Example

### Ethereum (ETH)

Uses Docker Compose to deploy an Ethereum full node.

**Prerequisites:**

*   Docker
*   Docker Compose

**Instructions:**

1.  Navigate to the `eth` directory:
    ```bash
    cd eth
    ```
2.  Run the initialization script:
    ```bash
    ./init-eth.sh
    ```
3.  Start the node:
    ```bash
    docker compose up -d
    ```