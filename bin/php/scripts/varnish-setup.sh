#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PHP_BIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PHP_BIN_DIR/../.." && pwd)"

source "$SCRIPT_DIR/common.sh"
source "$SCRIPT_DIR/load-env.inc.sh"

MAGENTO_ROOT="/var/www/html"
VARNISH_SERVICE_HOST="varnish"
VARNISH_ACCESS_LIST="localhost,${PHP_FPM_CONTAINER}"

info "Configuring Magento full page cache for Varnish"

docker_exec_php "
cd '${MAGENTO_ROOT}'

php bin/magento config:set system/full_page_cache/caching_application 2
php bin/magento config:set system/full_page_cache/varnish/backend_host '${NGINX_CONTAINER}'
php bin/magento config:set system/full_page_cache/varnish/backend_port '${CONTAINER_NGINX_HTTP_PORT}'
php bin/magento config:set system/full_page_cache/varnish/access_list '${VARNISH_ACCESS_LIST}'
php bin/magento config:set system/full_page_cache/varnish/grace_period 300
php bin/magento --no-interaction setup:config:set --http-cache-hosts='${VARNISH_SERVICE_HOST}:${CONTAINER_VARNISH_PORT}'
php bin/magento cache:flush
"

ok "Magento Varnish configuration completed"
