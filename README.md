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

## GitLab CI example

```yml
clairctl report --host "$CLAIR_ENDPOINT" "$IMAGE_NAME" > report.xml

cves=$(cat report.xml | grep -c " found ")
if [ "$cves" -gt 0 ]
then
    cat report.xml
    exit 1
fi
exit 0
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
