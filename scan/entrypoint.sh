#!/bin/bash

set -e # exit on any error

if [ -z "$REGISTRY_ENDPOINT" ]
then
    echo "Not registering to any registry due to empty REGISTRY_ENDPOINT variable"
else
    echo "Trying to register to $REGISTRY_ENDPOINT with user $REGISTRY_USERNAME"
    HOME="/tmp/$(uuid)"
    mkdir "$HOME/.docker"
    echo "$REGISTRY_PASSWORD" | docker login --username "$REGISTRY_USERNAME" --password-stdin "$REGISTRY_ENDPOINT"
fi

echo "Scanning image $IMAGE_NAME against Clair endpoint $CLAIR_ENDPOINT"
clairctl report --host "$CLAIR_ENDPOINT" "$IMAGE_NAME" > report.xml

cves=$(cat report.xml | grep -c " found ")
if [ "$cves" -gt 0 ]
then
    cat report.xml
    exit 1
fi
exit 0
