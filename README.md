# clair-docker

[![Linux build of clair-docker](https://github.com/flavienbwk/clair-docker/actions/workflows/main.yml/badge.svg)](https://github.com/flavienbwk/clair-docker/actions/workflows/main.yml)

Deployment-ready docker configuration and instructions to use Quay Clair on your infrastructure and CIs

> 🌟 If this repo helped you please leave a star !  
> :smiley: Suggestions and feedbacks are [highly appreciated](https://github.com/flavienbwk/clair-docker/issues/new)

## Start Clair server

Run the following command, then wait about 5 minutes the time Clair indexes all CVEs.

```bash
docker-compose up -d
```

## Scanning an image

Use the utility container I've provided to easily scan an image, including one from a private registry.

1. Check the env variables of [scan.docker-compose.yml](./scan.docker-compose.yml)

2. Run the scan !

    ```bash
    docker-compose -f scan.docker-compose.yml up
    ```

    You can try this vulnerable image : `quay.io/noseka1/deep-dive-into-clair`

## Integrating with your CI

1. Build the scan image and tag it

    ```bash
    docker build ./scan -t ghcr.io/flavienbwk/clair-docker/quay-clair-scan:v4.3.0
    ```

2. Push the image to your registry

3. Adapt the following command to your CI

    ```bash
    docker run --rm -e IMAGE_NAME="node:10-alpine" -e CLAIR_ENDPOINT="http://172.17.0.1:6060" -e REGISTRY_ENDPOINT="" -e REGISTRY_USERNAME="" -e REGISTRY_PASSWORD="" --privileged --network="host" -it ghcr.io/flavienbwk/clair-docker/quay-clair-scan:v4.3.0
    echo "Exit code : $?"
    ```

## Updating for air-gapped systems

You must first have a connected Clair cluster initialized to perform the following actions

1. On internet-connected machine :

    ```bash
    clairctl --config clair_config/config.yml export-updaters updates.gz
    ```

    :information_source: The archive will be ~8.5Gb

2. Transfer the `updates.gz` archive and run :

    ```bash
    clairctl import-updaters http://web.svc/updates.gz
    ```

3. Matcher processes should have the disable_updaters key set to disable automatic updaters running.

    ```yml
    matcher:
        disable_updaters: true
    ```

## Learn more

To learn more about Quay Clair, I recommend you :

- The [official Clair documentation](https://quay.github.io/clair/)
- Ales Nosek's video ["Deeping Dive into Image Vulnerabillity"](https://www.youtube.com/watch?v=kLpEbUBn06A)
