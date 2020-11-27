FROM rust:latest as builder

RUN USER=root cargo new --bin rust-api-date
WORKDIR ./rust-api-date
COPY ./Cargo.toml ./Cargo.toml
RUN cargo build --release

ADD . ./

RUN cargo build --release

FROM debian:buster-slim
ARG APP=/opt/app

RUN apt-get update \
    && apt-get install -y ca-certificates tzdata \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 8000

ENV TZ Europe/Paris
RUN cp /usr/share/zoneinfo/Europe/Paris /etc/localtime
ENV USER=app_rust

RUN groupadd $USER \
    && useradd -g $USER $USER \
    && mkdir -p ${APP}

COPY --from=builder /rust-date-api/target/release/rust-api-date ${APP}/rust-date-api

RUN chown -R $USER:$USER ${APP}

USER $USER
WORKDIR ${APP}

CMD ["./rust-date-api"]
