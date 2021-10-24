# clair-docker

Deployment-ready docker configuration and instructions to use Quay Clair on your infrastructure and CIs

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
