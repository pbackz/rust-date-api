FROM rust:latest as builder

RUN USER=root cargo new --bin rust-date-api
WORKDIR ./rust-date-api
RUN rustup toolchain install nightly
RUN rustup override set nightly
RUN cargo build --release

ADD . ./

RUN cargo build --release

FROM debian:buster-slim
ARG APP=/opt/app

RUN apt-get update \
    && apt-get install -y ca-certificates tzdata \
    && rm -rf /var/lib/apt/lists/*

ENV TZ Europe/Paris
RUN cp /usr/share/zoneinfo/Europe/Paris /etc/localtime
ENV USER=app_rust

RUN groupadd $USER \
    && useradd -g $USER $USER \
    && mkdir -p ${APP}

COPY --from=builder /rust-date-api/target/release/rust-date-api ${APP}/rust-date-api

RUN chown -R $USER:$USER ${APP}

USER $USER
WORKDIR ${APP}

EXPOSE 80 8000

CMD ["./rust-date-api"]
