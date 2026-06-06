#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PHP_BIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PHP_BIN_DIR/../.." && pwd)"

source "$SCRIPT_DIR/common.sh"
source "$SCRIPT_DIR/load-env.inc.sh"

MAGENTO_ROOT="/var/www/html"
MAILPIT_SERVICE_HOST="mailpit"

info "Configuring Magento SMTP for Mailpit"

docker_exec_php "
cd '${MAGENTO_ROOT}'

php bin/magento config:set system/smtp/transport smtp
php bin/magento config:set system/smtp/host '${MAILPIT_SERVICE_HOST}'
php bin/magento config:set system/smtp/port '${CONTAINER_MAILPIT_SMTP_PORT}'
php bin/magento config:set system/smtp/set_return_path 0
php bin/magento cache:flush
"

ok "Magento Mailpit SMTP configuration completed"
