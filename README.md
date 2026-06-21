# deploy-chain-fullnode

一键部署多链全节点 — 基于 Docker Compose 的生产级区块链节点编排仓库。

## 支持的链

| 链 | 目录 | 客户端 | 类型 |
|---|---|---|---|
| Ethereum Mainnet | `eth/` | Geth + Nimbus | L1 |
| Sepolia Testnet | `sepolia/` | Geth + Nimbus | L1 测试网 |
| BNB Chain | `bnb/` | BSC Geth (自构建) | L1 |
| BNB Testnet | `bnbtestnet/` | BSC Geth (自构建) | L1 测试网 |
| Arbitrum One | `arbone/` | Nitro (offchainlabs/nitro-node) | L2 |
| Linea | `linea/` | Geth (genesis 初始化) | L2 |
| Scroll | `scroll/` | scrolltech/l2geth | L2 |

## 前置条件

| 依赖 | 最低版本 |
|---|---|
| Docker | ≥ 24.0 |
| Docker Compose | ≥ v2.20 |
| OpenSSL | ≥ 1.1 (仅 eth/sepolia 生成 JWT 用) |

> L2 链（Arbitrum、Scroll）启动前需预先配置 L1 RPC 端点环境变量，见下方[环境变量](#环境变量)。

## 快速启动

```bash
# 1. 克隆仓库
git clone git@github.com-personal:orange723/deploy-chain-fullnode.git
cd deploy-chain-fullnode

# 2. 进入目标链目录
cd eth

# 3. 运行初始化脚本（创建数据目录、JWT 等）
./init-eth.sh

# 4. 启动
docker compose up -d

# 5. 查看日志
docker compose logs -f
```

所有链的启动流程一致：`cd <链目录> && ./init-*.sh && docker compose up -d`

## 环境变量

部分链依赖外部服务，需要创建 `.env` 文件：

**Arbitrum One** (`arbone/`)
```bash
cp arbone/.env.example arbone/.env
# 编辑 .env，填入你的 L1 节点地址：
#   ARBONE_L1_URL=https://your-eth-node:8545
#   ARBONE_BEACON_URL=https://your-beacon-node:5052
```

**Scroll** (`scroll/`)
```bash
cp scroll/.env.example scroll/.env
# 编辑 .env：
#   SCROLL_L1_ENDPOINT=https://your-eth-node:8545
#   SCROLL_BEACON_ENDPOINT=https://your-beacon-node:5052
```

## 快照加速（Snapshot）

首次同步可能耗时数天，建议使用快照加速。

```bash
# 1. 停止节点
docker compose down

# 2. 下载并解压快照到数据目录
tar -xzf snapshot.tar.gz -C ./eth_data

# 3. 修正权限
sudo chown -R $(id -u):$(id -g) ./eth_data

# 4. 重启
docker compose up -d
```

> **重要**：快照路径必须匹配 `compose.yml` 中 `volumes` 的挂载路径。
>
> 快照来源：[publicnode.com/snapshots](https://www.publicnode.com/snapshots)

## 资源参考

| 链 | 建议内存 | 建议 CPU | 磁盘（归档模式） |
|---|---|---|---|
| Ethereum Mainnet | ≥ 16 GB | 4 核 | ≥ 2 TB SSD |
| Sepolia | ≥ 8 GB | 2 核 | ≥ 500 GB SSD |
| BNB Chain | ≥ 16 GB | 4 核 | ≥ 2 TB SSD |
| BNB Testnet | ≥ 8 GB | 2 核 | ≥ 500 GB SSD |
| Arbitrum One | ≥ 8 GB | 2 核 | ≥ 500 GB SSD |
| Linea | ≥ 8 GB | 2 核 | ≥ 500 GB SSD |
| Scroll | ≥ 8 GB | 2 核 | ≥ 500 GB SSD |

> 生产环境建议预留 20% 资源余量。每项 `compose.yml` 中已配置 `deploy.resources` 限制，可按需调整。

## 健康检查

所有服务均配置了 Docker `healthcheck`：

```bash
# 查看容器健康状态
docker compose ps

# 手动验证 RPC
curl -s -X POST http://localhost:8545 \
  -H 'Content-Type: application/json' \
  -d '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}'

# 检查同步进度（Geth 系）
docker compose exec geth geth attach --exec 'eth.syncing' http://localhost:8545
```

## 日志管理

所有服务使用 `json-file` 驱动 + 自动轮转（单文件 100MB，保留 3 个）：

```bash
docker compose logs -f --tail=100       # 实时跟踪
docker compose logs --since 1h geth     # 最近 1 小时
```

## 常见问题

| 现象 | 排查 |
|---|---|
| RPC 无响应 | `docker compose ps` 确认容器 Running 且 Healthy |
| 权限拒绝 | `chown -R $(id -u):$(id -g) ./data` |
| JWT 认证失败 | 确认 `jwt.hex` 在执行层和共识层容器中挂载路径一致 |
| 端口冲突 | 检查宿主机 8545/30303 端口占用 `lsof -i :8545` |
| 同步停滞 | 检查磁盘空间 `df -h`，磁盘满会导致同步卡死 |

## 生产环境检查清单

- [ ] 配置充足的磁盘 IOPS（NVMe SSD 推荐）
- [ ] 调优 `deploy.resources` 限制以匹配实际机器规格
- [ ] 配置外部监控（Prometheus + Grafana）/ 告警
- [ ] 启用防火墙规则，仅暴露必要的 RPC 端口
- [ ] 使用反向代理（Caddy/Nginx）暴露 RPC，而非直接暴露容器端口
- [ ] 定期备份数据目录并验证快照可恢复
- [ ] 配置日志聚合（Loki / ELK）

## 目录结构

```
.
├── .gitignore
├── README.md
├── eth/            # Ethereum 主网
├── sepolia/        # Sepolia 测试网
├── bnb/            # BNB Chain 主网
├── bnbtestnet/     # BNB Chain 测试网
├── arbone/         # Arbitrum One (Nitro)
├── linea/          # Linea
└── scroll/         # Scroll
```

每个链目录包含：
- `compose.yml` — Docker Compose 编排定义
- `init-*.sh` — 数据目录初始化脚本
- `.env.example`（如有外部依赖） — 环境变量模板
