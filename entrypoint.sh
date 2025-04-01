#!/bin/bash

RPC=${RPC:-"https://evmrpc-testnet.0g.ai"}

PRIVATE_KEY=${PRIVATE_KEY}

../target/release/zgs_node --config config-testnet-turbo.toml --blockchain-rpc-endpoint $RPC --miner-key $PRIVATE_KEY
