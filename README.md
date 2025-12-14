# deploy-chain-fullnode

本仓库收集了使用 Docker / Docker Compose 部署各类区块链全节点的参考配置与初始化脚本，目的是方便在本地或服务器上快速搭建不同链（L1/L2）的节点环境。

**支持的链（目录）**
- `eth`：Ethereum 主网（执行节点 + 共识客户端 示例）
- `sepolia`：Sepolia 测试网
- `bnb`：BNB 主网
- `bnbtestnet`：BNB 测试网
- `arbone`：Arbitrum One (Nitro)
- `linea`：Linea
- `scroll`：Scroll

## 链快照（Chain Snapshots）
为加速节点首次同步，可以使用链快照（snapshot）。常见来源：

- publicnode 快照： https://www.publicnode.com/snapshots

使用快照的基本步骤（通用）：

1. 停止正在运行的节点容器（若已启动）：
```bash
docker compose down
```
2. 将下载的快照解压到对应的数据目录（例如 `eth/eth_data` 或各链目录下的 `data`）：
```bash
# 假设 snapshot.tar.gz 在上级目录
tar -xzf snapshot.tar.gz -C ./eth/eth_data
```
3. 修正目录权限（确保容器进程能访问）：
```bash
sudo chown -R $(id -u):$(id -g) ./eth/eth_data
```
4. 启动容器：
```bash
docker compose up -d
```

注意：不同客户端/镜像使用的目录结构可能不同，务必对照 `compose.yml` 中挂载的宿主路径（volumes）把快照放到正确位置。

## 使用前准备
- 在宿主机上安装 `Docker` 和 `Docker Compose`。
- 根据需要准备快照文件，可显著减少首次同步时间。

## 快速启动（通用步骤）
1. 进入对应链目录，例如以太坊主网：
```bash
cd eth
```
2. 运行初始化脚本（创建数据目录、生成必要文件等）：
```bash
./init-eth.sh
```
3. 启动服务：
```bash
docker compose up -d
```

## 各链简要说明
- `eth`：使用 `ethereum/client-go`（Geth）作为执行客户端，示例包含 `statusim/nimbus-eth2` 作为共识客户端。`init-eth.sh` 会生成 `jwt.hex`（Engine API 用），并创建数据目录。
- `sepolia`：类似 `eth` 的测试网配置。
- `bnb` / `bnbtestnet`：包含用于 BSC 的 `Dockerfile`、`compose.yml` 和 `config.toml`，`init-bnb.sh` 会创建 `./data`。
- `arbone`：Nitro 节点（`offchainlabs/nitro-node`），需要配置上游 L1 节点 URL 与 blob 客户端。
- `linea`：包含 `genesis.json`，首次运行会执行 `geth init` 初始化数据目录。
- `scroll`：使用 `scrolltech/l2geth`，`compose.yml` 中含多处需配置的 L1/DA 地址占位。

## 常见故障排查提示
- 容器无法访问 RPC：检查端口映射、防火墙及容器日志（`docker compose logs -f <service>`）。
- 权限问题：确保宿主目录权限正确（`chown`/`chmod`）。
- JWT 问题（Eth/Engine）：`jwt.hex` 必须在执行与共识客户端之间共享并正确挂载。

## 示例：以太坊主网快速示例
```bash
cd eth
./init-eth.sh    # 创建数据目录并生成 jwt.hex
docker compose up -d
docker compose logs -f geth
```

## 备注
- 本仓库为参考配置。生产环境请根据机器资源（磁盘 I/O、内存、CPU）与业务需求调整客户端参数（如 `--cache`、`--gcmode`、`--syncmode` 等）。