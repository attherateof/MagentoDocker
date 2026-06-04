#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PHP_BIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PHP_BIN_DIR/../.." && pwd)"

source "$SCRIPT_DIR/common.sh"

ENV_FILE="$PROJECT_ROOT/.env"

[[ -f "$ENV_FILE" ]] || fail ".env file not found"

info "Loading .env"

set -a
source "$ENV_FILE"
set +a

export MAGENTO_VERSION="${MAGENTO_VERSION:-2.4.8}"
export CONTAINER_PRIMARY_OPENSEARCH_PORT="${CONTAINER_PRIMARY_OPENSEARCH_PORT:-9200}"

ok ".env loaded"