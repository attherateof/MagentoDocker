#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PHP_BIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PHP_BIN_DIR/../.." && pwd)"

source "$SCRIPT_DIR/common.sh"
source "$SCRIPT_DIR/load-env.inc.sh"

MAGENTO_ROOT="/var/www/html"
AUTH_SAMPLE="${MAGENTO_ROOT}/auth.json.sample"
AUTH_JSON="${MAGENTO_ROOT}/auth.json"
ADMIN_URI="admin_$(openssl rand -hex 4)"

export ADMIN_URI

mkdir -p "${PROJECT_ROOT}/build"
echo "$ADMIN_URI" > "${PROJECT_ROOT}/build/.admin_uri"

if docker_exec_php "[ -f '${MAGENTO_ROOT}/bin/magento' ]"; then
    info "Magento already exists. Skipping download."
else
    info "Removing existing Magento directory contents"
    docker_exec_php "find '${MAGENTO_ROOT}' -mindepth 1 -maxdepth 1 -exec rm -rf {} +"

    info "Downloading Magento ${MAGENTO_VERSION}"
    docker_exec_php "export XDEBUG_MODE=off && composer create-project --repository-url=https://repo.magento.com magento/project-community-edition='${MAGENTO_VERSION}' '${MAGENTO_ROOT}'"

    ok "Magento download complete"
fi

if docker_exec_php "[ ! -f '${AUTH_JSON}' ] && [ -f '${AUTH_SAMPLE}' ]"; then
    docker_exec_php "cp '${AUTH_SAMPLE}' '${AUTH_JSON}' && sed -i -e 's|<public-key>|${COMPOSER_PUBLIC_KEY}|g' -e 's|<private-key>|${COMPOSER_PRIVATE_KEY}|g' '${AUTH_JSON}'"
    ok "auth.json created"
fi

if docker_exec_php "[ -f '${MAGENTO_ROOT}/bin/magento' ] && '${MAGENTO_ROOT}/bin/magento' setup:config:status >/dev/null 2>&1"; then
    info "Magento already installed. Skipping setup:install."
    exit 0
fi

info "Running Magento setup:install"

docker_exec_php "cd '${MAGENTO_ROOT}' && export XDEBUG_MODE=off && php bin/magento setup:install --base-url='${MAGENTO_BASE_URL}' --db-host='${MARIADB_CONTAINER}' --db-name='${MYSQL_DATABASE}' --db-user='${MYSQL_USER}' --db-password='${MYSQL_PASSWORD}' --admin-firstname='${MAGENTO_ADMIN_FIRSTNAME}' --admin-lastname='${MAGENTO_ADMIN_LASTNAME}' --admin-email='${MAGENTO_ADMIN_EMAIL}' --admin-user='${MAGENTO_ADMIN_USER}' --admin-password='${MAGENTO_ADMIN_PASSWORD}' --language='${MAGENTO_LANGUAGE}' --currency='${MAGENTO_CURRENCY}' --timezone='${MAGENTO_TIMEZONE}' --search-engine='opensearch' --opensearch-host='${PRIMARY_OPENSEARCH_CONTAINER}' --opensearch-port='${CONTAINER_PRIMARY_OPENSEARCH_PORT}' --backend-frontname='${ADMIN_URI}'"

ok "Magento installation completed"
