FROM docker:20.10-dind-rootless

USER 0
WORKDIR /usr/app

RUN apk update && apk add wget curl git uuidgen

# Install Go
RUN wget https://golang.org/dl/go1.17.2.linux-amd64.tar.gz
RUN mkdir -p /usr/app/go
RUN tar -xf go1.17.2.linux-amd64.tar.gz --directory /usr/app/go
ENV PATH="/usr/app/go/go/bin:/root/go/bin:${PATH}"

RUN GO111MODULE=on go install github.com/quay/clair/v4/cmd/clairctl@latest
RUN chmod +x /root && chmod +x /root/go && chmod +x /root/go/bin && chmod 755 "$(which clairctl)" && chmod +x "$(which clairctl)"

COPY ./entrypoint.sh /usr/app/entrypoint.sh
RUN chmod 755 /usr/app/entrypoint.sh && chmod +x /usr/app/entrypoint.sh

RUN echo "net.ipv4.ping_group_range = 0 2147483647" >> /etc/sysctl.conf

USER rootless
COPY ./dockerd-rootless.sh /home/rootless/dockerd-rootless.sh

ENTRYPOINT [ "sh", "/usr/app/entrypoint.sh" ]
