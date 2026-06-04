#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PHP_BIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PHP_BIN_DIR/../.." && pwd)"

source "$SCRIPT_DIR/common.sh"
source "$SCRIPT_DIR/load-env.inc.sh"

info "Running Magento post-install tasks"

docker_exec_php "
cd /var/www/html

php bin/magento setup:upgrade
php bin/magento deploy:mode:set developer
php bin/magento indexer:reindex
php bin/magento cache:flush
"

ok "Magento post-install tasks completed"
