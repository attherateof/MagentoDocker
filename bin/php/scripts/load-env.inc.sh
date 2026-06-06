#!/usr/bin/env bash

ENV_FILE="$PROJECT_ROOT/.env"

[[ -f "$ENV_FILE" ]] || fail ".env file not found"

set -a
source "$ENV_FILE"
set +a

export MAGENTO_VERSION="${MAGENTO_VERSION:-2.4.8}"
export MAGENTO_MODE="${MAGENTO_MODE:-developer}"
export CONTAINER_PRIMARY_OPENSEARCH_PORT="${CONTAINER_PRIMARY_OPENSEARCH_PORT:-9200}"
