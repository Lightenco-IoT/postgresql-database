#!/bin/bash

IMAGE_NAME=docker.io/postgres:14.10-alpine

NETWORK_NAME='template'

USER='postgres'
PASSWORD='postgres'

docker network exists "${NETWORK_NAME}" || docker network create "${NETWORK_NAME}"

# pull image if it does not exists
if ! docker image inspect "$IMAGE_NAME" &> /dev/null; then
    docker pull "$IMAGE_NAME"
fi

# folder where to store the postgresql data
DATA_FOLDER="$(pwd)/$(dirname "$0")/data/"

# ensure the folder exists
mkdir -p "${DATA_FOLDER}"

# give a recognizable name to the container
CONTAINER_NAME="postgresql-container"

# get latest image
docker pull "${IMAGE_NAME}"

# start the postgresql container
docker run \
    --rm \
    --name "${CONTAINER_NAME}" \
    --publish 127.0.0.1:5432:5432 \
    --env POSTGRES_USER="${USER}" \
    --env POSTGRES_PASSWORD="${PASSWORD}" \
    --volume "${DATA_FOLDER}":/var/lib/postgresql/data \
    --network "${NETWORK_NAME}" \
    "${IMAGE_NAME}"
