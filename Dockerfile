FROM rust:bullseye AS builder

RUN apt update && apt install -y wget clang cmake build-essential pkg-config libssl-dev git

WORKDIR /usr/src/app

RUN git clone https://github.com/0glabs/0g-storage-node.git && \
    cd 0g-storage-node && \
    git -c advice.detachedHead=false checkout $(git describe --tags $(git rev-list --tags --max-count=1)) && \
    cargo build --release

FROM debian:bullseye-slim

RUN apt update && apt install -y ca-certificates && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/src/app/0g-storage-node /usr/src/app/0g-storage-node

# 设置工作目录
WORKDIR /usr/src/app/0g-storage-node/run

COPY entrypoint.sh entrypoint.sh

RUN chmod +x entrypoint.sh

# 设置默认命令
ENTRYPOINT ["./entrypoint.sh"]
