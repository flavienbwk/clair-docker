FROM ubuntu:21.04

WORKDIR /usr/app

RUN apt update && apt install -y wget curl git uuid

# Install Go
RUN wget https://golang.org/dl/go1.17.2.linux-amd64.tar.gz
RUN mkdir -p /usr/app/go
RUN tar -xf go1.17.2.linux-amd64.tar.gz --directory /usr/app/go
ENV PATH="/usr/app/go/go/bin:/root/go/bin:${PATH}"

RUN GO111MODULE=on go install github.com/quay/clair/v4/cmd/clairctl@latest

COPY ./entrypoint.sh /usr/app/entrypoint.sh
ENTRYPOINT [ "bash", "/usr/app/entrypoint.sh" ]
