#!/bin/bash

set -e # exit on any error

# Setting up Docker Rootless mode
export HOME="/tmp/$(uuidgen)"
export XDG_RUNTIME_DIR="$HOME/.docker/xrd"
export DOCKER_HOST=unix://$XDG_RUNTIME_DIR/docker.sock
mkdir -p "$XDG_RUNTIME_DIR"

# Running Docker Rootless in background
# then wait for it
/home/rootless/dockerd-rootless.sh &
while (! docker stats --no-stream ); do
    echo "Waiting 1 second for Docker to start up..."
    sleep 1
done

if [ -z "$REGISTRY_USERNAME" ]
then
    echo "Not registering to any registry due to empty REGISTRY_ENDPOINT variable"
else
    echo "Trying to register to $REGISTRY_ENDPOINT with user $REGISTRY_USERNAME"
    echo "$REGISTRY_PASSWORD" | docker login --username "$REGISTRY_USERNAME" --password-stdin "$REGISTRY_ENDPOINT"
fi

echo "Pulling $IMAGE_NAME..."
docker pull "$IMAGE_NAME"
echo "OK: pulled $IMAGE_NAME."
echo "Scanning image $IMAGE_NAME against Clair endpoint $CLAIR_ENDPOINT..."
clairctl report --host "$CLAIR_ENDPOINT" "$IMAGE_NAME" > "$HOME/report.xml"
echo "Finished scanning."

cat "$HOME/report.xml"

cves=$(cat "$HOME/report.xml" | grep " found " | wc -l)
if [ "$cves" -gt 0 ]
then
    cat "$HOME/report.xml"
    exit 1
fi

echo "No issue detected for $IMAGE_NAME !"
exit 0
