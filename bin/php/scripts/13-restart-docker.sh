#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PHP_BIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PHP_BIN_DIR/../.." && pwd)"

source "$SCRIPT_DIR/common.sh"

info "Rebuilding and restarting Nginx and Varnish"

docker_compose_full build nginx varnish

docker_compose_full up -d nginx varnish

ok "Nginx and Varnish rebuilt and restarted"
