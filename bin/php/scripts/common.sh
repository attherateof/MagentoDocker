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

compose_full_files() {
    local files=(
        -f "$PROJECT_ROOT/docker-compose.yml"
        -f "$PROJECT_ROOT/docker-compose.override.yml"
        -f "$PROJECT_ROOT/docker-compose.mailpit.yml"
        -f "$PROJECT_ROOT/docker-compose.node.yml"
        -f "$PROJECT_ROOT/docker-compose.jenkins.yml"
        -f "$PROJECT_ROOT/docker-compose.logstash.yml"
        -f "$PROJECT_ROOT/docker-compose.varnish.yml"
    )
    printf '%s\n' "${files[@]}"
}

docker_compose_full() {
    local args=()
    while IFS= read -r line; do
        args+=("$line")
    done < <(compose_full_files)
    docker compose -p magento "${args[@]}" "$@"
}

docker_exec_php() {
    docker exec -i -w / "$PHP_FPM_CONTAINER" bash -lc "$*"
}

docker_exec_php_root() {
    docker exec -i -u 0 -w / "$PHP_FPM_CONTAINER" bash -lc "$*"
}

docker_exec_db() {
    # If caller provides multiple args, pass them directly to docker exec
    # to avoid shell-quoting issues. If a single string is provided, fall
    # back to running it via the container shell for compatibility.
    if [ "$#" -gt 1 ]; then
        docker exec -i -w / "$MARIADB_CONTAINER" "$@"
    else
        docker exec -i -w / "$MARIADB_CONTAINER" bash -lc "$1"
    fi
}