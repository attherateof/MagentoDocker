#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PHP_BIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PHP_BIN_DIR/../.." && pwd)"

source "$SCRIPT_DIR/common.sh"

ENV_FILE="$PROJECT_ROOT/.env"

set -a
source "$ENV_FILE"
set +a

required_vars=(
    PHP_FPM_CONTAINER
    NGINX_CONTAINER
    MARIADB_CONTAINER
    PRIMARY_OPENSEARCH_CONTAINER
    MYSQL_DATABASE
    MYSQL_USER
    MYSQL_PASSWORD
    COMPOSER_PUBLIC_KEY
    COMPOSER_PRIVATE_KEY
    MAGENTO_BASE_URL
    MAGENTO_ADMIN_FIRSTNAME
    MAGENTO_ADMIN_LASTNAME
    MAGENTO_ADMIN_EMAIL
    MAGENTO_ADMIN_USER
    MAGENTO_ADMIN_PASSWORD
    MAGENTO_LANGUAGE
    MAGENTO_CURRENCY
    MAGENTO_TIMEZONE
)

for var in "${required_vars[@]}"; do
    [[ -n "${!var:-}" ]] || fail "$var is missing"
done

[[ "$COMPOSER_PUBLIC_KEY" != *xxxx* ]] \
    || fail "COMPOSER_PUBLIC_KEY contains placeholder value"

[[ "$COMPOSER_PRIVATE_KEY" != *xxxx* ]] \
    || fail "COMPOSER_PRIVATE_KEY contains placeholder value"

ok "Environment validation successful"