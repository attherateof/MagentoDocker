#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PHP_BIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PHP_BIN_DIR/../.." && pwd)"

source "$SCRIPT_DIR/common.sh"
source "$SCRIPT_DIR/load-env.inc.sh"

[[ "${INSTALL_SAMPLE_DATA}" == "true" ]] || exit 0

info "Installing Magento sample data"

docker_exec_php "
cd /var/www/html

export XDEBUG_MODE=off

php bin/magento sampledata:deploy
composer update
"

ok "Magento sample data installed"
