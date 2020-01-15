FROM alpine:latest

LABEL maintainer="n11c dev@n11c.co"

ENV PATH="/.tfenv/bin:/.tgenv/bin:${PATH}"

RUN apk add --no-cache \
    bash \
    build-base \
    ca-certificates \
    curl \
    git \
    gnupg \
    make \
    python \
    unzip && update-ca-certificates

# Provide compatibility for Go binaries compiled against glibc (e.g. tflint)
# reference: https://stackoverflow.com/a/35613430
RUN mkdir /lib64 && ln -s /lib/libc.musl-x86_64.so.1 /lib64/ld-linux-x86-64.so.2

# terraform
ARG terraform_versions="0.12.15 0.12.16 0.12.17"
RUN git clone https://github.com/tfutils/tfenv.git /.tfenv && \
    for version in ${terraform_versions}; do /.tfenv/bin/tfenv install ${version}; done

# terragrunt
ARG terragrunt_versions="0.21.6 0.21.11"
RUN git clone https://github.com/cunymatthieu/tgenv.git /.tgenv && \
    for version in ${terragrunt_versions}; do /.tgenv/bin/tgenv install ${version}; done

# tflint
ARG tflint_version="0.13.4"
RUN curl -sLO https://github.com/wata727/tflint/releases/download/v${tflint_version}/tflint_linux_amd64.zip && unzip tflint_linux_amd64.zip && mv tflint /bin
