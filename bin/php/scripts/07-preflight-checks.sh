#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PHP_BIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PHP_BIN_DIR/../.." && pwd)"

source "$SCRIPT_DIR/common.sh"

set -a
source "$PROJECT_ROOT/.env"
set +a

for container in \
    "$PHP_FPM_CONTAINER" \
    "$MARIADB_CONTAINER" \
    "$PRIMARY_OPENSEARCH_CONTAINER"
do
    docker ps \
        --format '{{.Names}}' \
        | grep -Fx "$container" \
        >/dev/null \
        || fail "$container is not running"
done

ok "Container validation successful"