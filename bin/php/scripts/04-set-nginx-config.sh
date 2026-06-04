#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PHP_BIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PHP_BIN_DIR/../.." && pwd)"

source "$SCRIPT_DIR/common.sh"
source "$SCRIPT_DIR/load-env.inc.sh"

NGINX_CONF_DIR="${PROJECT_ROOT}/docker/images/nginx/conf"
GENERIC_CONF_SAMPLE="${NGINX_CONF_DIR}/generic.conf.sample"
DEFAULT_CONF="${NGINX_CONF_DIR}/default.conf"

if [ ! -f "$GENERIC_CONF_SAMPLE" ]; then
    fail "Nginx config sample not found: $GENERIC_CONF_SAMPLE"
fi

info "Copying ${GENERIC_CONF_SAMPLE} to ${DEFAULT_CONF}"
cp "$GENERIC_CONF_SAMPLE" "$DEFAULT_CONF"

if [ -n "${MAGENTO_BASE_URL:-}" ]; then
    SERVER_NAME=$(echo "$MAGENTO_BASE_URL" | sed -E 's|https?://||g' | sed 's|/$||g')
    info "Setting server_name to ${SERVER_NAME} in ${DEFAULT_CONF}"
    sed -i "s/server_name localhost;/server_name ${SERVER_NAME};/g" "$DEFAULT_CONF"
fi

ok "Nginx config set up"
