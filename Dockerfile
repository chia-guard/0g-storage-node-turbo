FROM rust:bullseye AS builder

RUN apt update && apt install -y wget clang cmake build-essential pkg-config libssl-dev git

WORKDIR /app

RUN git clone https://github.com/0glabs/0g-storage-node.git && \
    cd 0g-storage-node && \
    git checkout @peter/update-docker && \
    cargo build --release

FROM debian:bullseye-slim

RUN apt update && apt install -y ca-certificates && rm -rf /var/lib/apt/lists/*

COPY --from=builder /app/0g-storage-node/run /app/0g-storage-node/run
COPY --from=builder /app/0g-storage-node/target/release/zgs_node /app/0g-storage-node/target/release/zgs_node

WORKDIR /app/0g-storage-node/run

COPY entrypoint.sh /app/0g-storage-node/run/entrypoint.sh

RUN chmod +x /app/0g-storage-node/run/entrypoint.sh

# 设置默认命令
ENTRYPOINT ["./entrypoint.sh"]
