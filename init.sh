#!/bin/bash
set -e

usage() {
  echo "用法: ./init.sh <链名>"
  echo ""
  echo "支持的链:"
  echo "  eth          Ethereum 主网 (Geth + Nimbus)"
  echo "  sepolia      Sepolia 测试网 (Geth + Nimbus)"
  echo "  bnb          BNB Chain 主网"
  echo "  bnbtestnet   BNB Chain 测试网"
  echo "  arbone       Arbitrum One (Nitro)"
  echo "  linea        Linea"
  echo "  scroll       Scroll"
  echo ""
  echo "示例:"
  echo "  ./init.sh eth && cd eth && docker compose up -d"
  exit 0
}

[ "$1" = "-h" ] || [ "$1" = "--help" ] && usage
[ -z "$1" ] && { echo "错误: 缺少链名。 ./init.sh --help 查看帮助"; exit 1; }

chain="$1"
dir=""

case "$chain" in
  eth)
    dir="eth"
    mkdir -p "$dir/eth_data" "$dir/nimbus_data"
    if [ ! -f "$dir/jwt.hex" ]; then
      echo "[eth] 生成 jwt.hex ..."
      openssl rand -hex 32 > "$dir/jwt.hex"
    else
      echo "[eth] jwt.hex 已存在，跳过"
    fi
    ;;
  sepolia)
    dir="sepolia"
    mkdir -p "$dir/eth_data" "$dir/nimbus_data"
    if [ ! -f "$dir/jwt.hex" ]; then
      echo "[sepolia] 生成 jwt.hex ..."
      openssl rand -hex 32 > "$dir/jwt.hex"
    else
      echo "[sepolia] jwt.hex 已存在，跳过"
    fi
    ;;
  bnb|bnbtestnet)
    dir="$chain"
    mkdir -p "$dir/data"
    ;;
  arbone)
    dir="arbone"
    mkdir -p "$dir/data" "$dir/snapdata"
    ;;
  linea|scroll)
    dir="$chain"
    mkdir -p "$dir/data"
    ;;
  *)
    echo "错误: 不支持的链 '$chain'。 ./init.sh --help 查看支持的链"
    exit 1
    ;;
esac

echo "[$chain] 数据目录已就绪 — cd $dir && docker compose up -d"
