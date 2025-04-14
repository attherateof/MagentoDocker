#!/bin/bash

# Define the PHP container name
DOCKER_CONTAINER="m246-php-fpm-1"

# Ensure a command is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <command>"
    exit 1
fi

# Run the command inside the Docker container
docker exec -it $DOCKER_CONTAINER bash -c "$@"
