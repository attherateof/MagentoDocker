#!/usr/bin/env bash
set -Eeuo pipefail

info() {
    printf '\n[INFO] %s\n' "$*"
}

ok() {
    printf '\n[SUCCESS] %s\n' "$*"
}

fail() {
    printf '\n[ERROR] %s\n' "$*" >&2
    exit 1
}

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

ENV_FILE="${PROJECT_ROOT}/.env"
[[ -f "$ENV_FILE" ]] || fail ".env file not found: $ENV_FILE"

PHP_FPM_CONTAINER="$(cat "$ENV_FILE" | grep -E '^[[:space:]]*PHP_FPM_CONTAINER=' | tail -n1 | cut -d= -f2-)"
PHP_FPM_CONTAINER="${PHP_FPM_CONTAINER#${PHP_FPM_CONTAINER%%[![:space:]]*}}"
PHP_FPM_CONTAINER="${PHP_FPM_CONTAINER%${PHP_FPM_CONTAINER##*[![:space:]]}}"
PHP_FPM_CONTAINER="${PHP_FPM_CONTAINER//\"/}"
PHP_FPM_CONTAINER="${PHP_FPM_CONTAINER//\'/}"

if [ -z "${PHP_FPM_CONTAINER:-}" ]; then
    fail "PHP_FPM_CONTAINER is not set in ${ENV_FILE}"
fi

XDEBUG_INI="${PROJECT_ROOT}/docker/images/php/conf/php.ini"
XDEBUG_INI_SAMPLE="${PROJECT_ROOT}/docker/images/php/conf/php.ini.sample"
if [ ! -f "$XDEBUG_INI" ]; then
    fail "Xdebug config not found: $XDEBUG_INI"
fi

if [ ! -f "$XDEBUG_INI_SAMPLE" ]; then
    info "Creating backup of php.ini at ${XDEBUG_INI_SAMPLE}"
    cp "$XDEBUG_INI" "$XDEBUG_INI_SAMPLE"
fi

info "Enabling Xdebug in ${XDEBUG_INI}"

replace_ini_setting() {
    local key="$1"
    local value="$2"

    if grep -qE "^[[:space:]]*${key}[[:space:]]*=" "$XDEBUG_INI"; then
        sed -i -E "s|^[[:space:]]*${key}[[:space:]]*=.*|${key}=${value}|" "$XDEBUG_INI"
    else
        if grep -qE "^[[:space:]]*\[xdebug\]" "$XDEBUG_INI"; then
            sed -i -E "/^[[:space:]]*\[xdebug\]/a ${key}=${value}" "$XDEBUG_INI"
        else
            printf '\n[xdebug]\n%s=%s\n' "$key" "$value" >> "$XDEBUG_INI"
        fi
    fi
}

if grep -qE "^[[:space:]]*zend_extension=.*xdebug" "$XDEBUG_INI"; then
    info "Xdebug extension already enabled in ${XDEBUG_INI}"
else
    if grep -qE "^[[:space:]]*\[xdebug\]" "$XDEBUG_INI"; then
        sed -i -E "/^[[:space:]]*\[xdebug\]/a zend_extension=xdebug.so" "$XDEBUG_INI"
    else
        printf '\n[xdebug]\nzend_extension=xdebug.so\n' >> "$XDEBUG_INI"
    fi
fi

replace_ini_setting "xdebug.mode" "debug,develop,profile"
replace_ini_setting "xdebug.start_with_request" "yes"
replace_ini_setting "xdebug.discover_client_host" "true"

info "Rebuilding php-fpm Docker image"
docker compose -p magento -f "${PROJECT_ROOT}/docker-compose.yml" build php-fpm

info "Restarting php-fpm container ${PHP_FPM_CONTAINER}"
if docker ps -a --format '{{.Names}}' | grep -qx -- "${PHP_FPM_CONTAINER}"; then
    docker restart "${PHP_FPM_CONTAINER}"
else
    docker compose -p magento -f "${PROJECT_ROOT}/docker-compose.yml" up -d php-fpm
fi

ok "Xdebug enabled and php-fpm rebuilt/restarted"
