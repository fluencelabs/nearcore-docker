FROM ubuntu:22.04 as builder
ARG NEAR_VERSION=master

RUN apt-get update -qq && apt-get install -y \
    git \
    cmake \
    g++ \
    pkg-config \
    libssl-dev \
    curl \
    llvm \
    clang \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/near/nearcore --branch ${NEAR_VERSION}
WORKDIR /nearcore

ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH

RUN curl https://sh.rustup.rs -sSf | \
    sh -s -- -y --no-modify-path --default-toolchain none

ENV PORTABLE=ON CARGO_TARGET_DIR=/tmp/target
RUN cargo build -p neard --release


FROM ubuntu:22.04

RUN apt-get update -qq && apt-get install -y \
    libssl-dev ca-certificates \
    && rm -rf /var/lib/apt/lists/*

ENV NEAR_HOME=/root/.near

COPY entrypoint.sh /entrypoint.sh
COPY --from=builder /tmp/target/release/neard /usr/local/bin/
ENTRYPOINT ["/entrypoint.sh"]
CMD ["run"]
