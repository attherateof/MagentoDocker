#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PHP_BIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PHP_BIN_DIR/../.." && pwd)"

source "$SCRIPT_DIR/common.sh"

COMPOSE_FILES=(
    -f "$PROJECT_ROOT/docker-compose.yml"
    -f "$PROJECT_ROOT/docker-compose.override.yml"
    -f "$PROJECT_ROOT/docker-compose.mailpit.yml"
    -f "$PROJECT_ROOT/docker-compose.node.yml"
    -f "$PROJECT_ROOT/docker-compose.jenkins.yml"
    -f "$PROJECT_ROOT/docker-compose.logstash.yml"
    -f "$PROJECT_ROOT/docker-compose.varnish.yml"
)

echo "[INFO] Building full Docker stack"

docker compose -p magento "${COMPOSE_FILES[@]}" build
ok "Full Docker stack build complete"
