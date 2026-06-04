#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PHP_BIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PHP_BIN_DIR/../.." && pwd)"

source "$SCRIPT_DIR/common.sh"
source "$SCRIPT_DIR/load-env.inc.sh"

info "Validating PHP version"

PHP_VERSION="$(docker_exec_php "php -r 'echo PHP_MAJOR_VERSION . \".\" . PHP_MINOR_VERSION;'" )"

info "Detected PHP version: ${PHP_VERSION}"

[[ "$PHP_VERSION" == "8.4" ]] || fail "Magento 2.4.8 requires PHP 8.4. Detected: ${PHP_VERSION}"

ok "PHP version validation passed"

info "Validating Composer"

COMPOSER_VERSION="$(docker_exec_php "composer --version")" || fail "Composer is not installed"

info "$COMPOSER_VERSION"

ok "Composer validation passed"

info "Checking MariaDB connectivity"

# Call docker_exec_db with separate arguments to avoid double-quoting issues
# Use the 'mariadb' client binary (some images provide 'mariadb' instead of 'mysql')
docker_exec_db mariadb -u"$MYSQL_USER" -p"$MYSQL_PASSWORD" "$MYSQL_DATABASE" -e 'SELECT 1;' >/dev/null || fail "Unable to connect to MariaDB"

ok "MariaDB connectivity check passed"

info "Checking OpenSearch"

docker_exec_php "curl -fsS http://${PRIMARY_OPENSEARCH_CONTAINER}:${CONTAINER_PRIMARY_OPENSEARCH_PORT}" >/dev/null || fail "OpenSearch is unreachable"

ok "OpenSearch connectivity check passed"

info "Configuring Magento Composer authentication"

docker_exec_php "composer config -g http-basic.repo.magento.com \"$COMPOSER_PUBLIC_KEY\" \"$COMPOSER_PRIVATE_KEY\""

ok "Composer authentication configured"
