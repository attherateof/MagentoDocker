#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PHP_BIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PHP_BIN_DIR/../.." && pwd)"

source "$SCRIPT_DIR/common.sh"

NGINX_CONF_DIR="$PROJECT_ROOT/docker/images/nginx/conf"

DEFAULT_CONF="$NGINX_CONF_DIR/default.conf"
DEFAULT_BAK="$NGINX_CONF_DIR/default.conf.bak"

MAGENTO_CONF="$NGINX_CONF_DIR/magento.conf.sample"

[[ -f "$DEFAULT_CONF" ]] || fail "default.conf not found"

cp "$DEFAULT_CONF" "$DEFAULT_BAK"

cp "$MAGENTO_CONF" "$DEFAULT_CONF"

ok "Nginx Magento configuration enabled"
