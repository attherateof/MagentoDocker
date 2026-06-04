#!/usr/bin/env bash
set -Eeuo pipefail

info() {
    printf '\n[INFO] %s\n' "$*"
}

ok() {
    printf '\n[SUCCESS] %s\n' "$*"
}

fail() {
    printf '\n[ERROR] %s\n' "$*" >&2
    exit 1
}

docker_compose() {
    docker compose \
        -p magento \
        -f "$PROJECT_ROOT/docker-compose.yml" \
        "$@"
}

docker_exec_php() {
    docker exec -i "$PHP_FPM_CONTAINER" bash -lc "$*"
}

docker_exec_db() {
    # If caller provides multiple args, pass them directly to docker exec
    # to avoid shell-quoting issues. If a single string is provided, fall
    # back to running it via the container shell for compatibility.
    if [ "$#" -gt 1 ]; then
        docker exec -i "$MARIADB_CONTAINER" "$@"
    else
        docker exec -i "$MARIADB_CONTAINER" bash -lc "$1"
    fi
}