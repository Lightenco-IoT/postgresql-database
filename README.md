# PostgresSQL
Database environment used in Quini.

For more information in [PostgreSQL website](https://www.postgresql.org).

## Important:
The script inside this repository uses Docker to launch automatically the service. You can always skip the script, and use directly the PostgreSQL server launcher. [Download PostgreSQL Server](https://www.postgresql.org/download/).

## Script for local development usage

### start

You can execute `launch.sh` to quickly start the postgres service temporary.

Default values are:
  - database => `postgres`.
  - user => `postgres`
  - password => `postgres`
  - data folder path relative to this _README.md_ => `./data`.
  - container name => `postgresql-container`.
  - image name => `docker.io/postgres:14-alpine`.
  - network name => `quini`.

Here is the details of the command:

```shell
# detailled version, explained line by line

docker run \  # run a container
  --rm \  # remove the container after it stop
  --name "${CONTAINER_NAME}" \  # give a name to the container to target it easier
  --publish 5432:5432 \  # bind local 5432 port to the container 5432 port
  --env 'POSTGRES_USER=postgres' \  # set an environment variable inside the container
  --env 'POSTGRES_PASSWORD=postgres' \  # set an environment variable inside the container
  --volume "${DATA_FOLDER}":/var/lib/postgresql/data \  # mount a folder to let postgresql store its files
  --network "${NETWORK_NAME}" \  # connect the container onto a private internal network
  "${IMAGE_NAME}"  # the image used by the container
```

### stop

Simply stop the container:

```shell
docker stop "${CONTAINER_NAME}"
```

### clean / reset data

Make sure you stopped the service first.

Then you can proceed by simply removing the data folder:

```shell
rm -rf "${DATA_FOLDER}"
```
