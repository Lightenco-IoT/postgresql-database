#!/bin/bash

IMAGE_NAME=docker.io/postgres:14-alpine

if [ -f .env ]; then
    while IFS= read -r line; do
        eval "$line"
    done < .env
fi

DB_PORT=${DB_PORT:-5432}
DB_USER=${DB_USER:-"postgres"}
DB_PASSWORD=${DB_PASSWORD:-"postgres"}

NETWORK_NAME=${DOCKER_NETWORK:-"docker0"}
PROJECT_NAME=${PROJECT_NAME:-"default"}


if docker network ls --format '{{.Name}}' | grep -wq "$NETWORK_NAME"; then
    echo "$NETWORK_NAME network exists"
else
    echo "$NETWORK_NAME creating network..."
    docker network create "$NETWORK_NAME"
fi


# folder where to store the postgresql data
DATA_FOLDER="$(pwd)/$(dirname "$0")/${PROJECT_NAME}_data"

# ensure the folder exists
mkdir -p "${DATA_FOLDER}"

# give a recognizable name to the container
CONTAINER_NAME="${PROJECT_NAME}-postgresql-container"

# get latest image
docker pull "${IMAGE_NAME}"

# start the postgresql container
docker run \
    --rm \
    --name "${CONTAINER_NAME}" \
    --publish "127.0.0.1:${DB_PORT}:5432" \
    --env "POSTGRES_USER=${DB_USER}" \
    --env "POSTGRES_PASSWORD=${DB_PASSWORD}" \
    --volume "${DATA_FOLDER}":/var/lib/postgresql/data \
    --network "${NETWORK_NAME}" \
    "${IMAGE_NAME}"

