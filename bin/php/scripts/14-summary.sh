#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PHP_BIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PHP_BIN_DIR/../.." && pwd)"

source "$SCRIPT_DIR/common.sh"
source "$SCRIPT_DIR/load-env.inc.sh"

if [[ -t 1 ]]; then
    COLOR_RESET=$'\033[0m'
    COLOR_BOLD=$'\033[1m'
    COLOR_CYAN=$'\033[36m'
    COLOR_GREEN=$'\033[32m'
    COLOR_YELLOW=$'\033[33m'
    COLOR_MAGENTA=$'\033[35m'
else
    COLOR_RESET=''
    COLOR_BOLD=''
    COLOR_CYAN=''
    COLOR_GREEN=''
    COLOR_YELLOW=''
    COLOR_MAGENTA=''
fi

ADMIN_URI=""
if [ -f "${PROJECT_ROOT}/build/app/etc/env.php" ]; then
    ADMIN_URI="$(grep -E "['\"]frontName['\"] *=> *['\"][^'\"]+['\"]" "${PROJECT_ROOT}/build/app/etc/env.php" | head -n1 | sed -E "s/.*['\"]frontName['\"] *=> *['\"]([^'\"]+)['\"].*/\1/")"
fi

if [ -n "${ADMIN_URI}" ]; then
    ADMIN_URL="${MAGENTO_BASE_URL}${ADMIN_URI}"
fi

SERVICE_URL_SCHEME="${MAGENTO_BASE_URL%%:*}"
SERVICE_URL_HOST="$(printf '%s' "$MAGENTO_BASE_URL" | sed -E 's#^[a-zA-Z]+://##; s#/.*$##')"
SERVICE_URL_HOST="${SERVICE_URL_HOST%%:*}"
if [[ "${SERVICE_URL_SCHEME}" != "http" && "${SERVICE_URL_SCHEME}" != "https" ]]; then
    SERVICE_URL_SCHEME="http"
fi
if [ -z "${SERVICE_URL_HOST}" ]; then
    SERVICE_URL_HOST="localhost"
fi
SERVICE_URL_PREFIX="${SERVICE_URL_SCHEME}://${SERVICE_URL_HOST}"

cat <<EOF

${COLOR_CYAN}${COLOR_BOLD}========================
MAGENTO INSTALLATION COMPLETE
========================${COLOR_RESET}

Magento Storefront URL
${COLOR_GREEN}${MAGENTO_BASE_URL}${COLOR_RESET}
EOF

if [ -n "${ADMIN_URI}" ]; then
cat <<EOF

${COLOR_YELLOW}Admin URL${COLOR_RESET}
${COLOR_GREEN}${ADMIN_URL}${COLOR_RESET}
EOF
fi

cat <<EOF

${COLOR_YELLOW}Admin User${COLOR_RESET}
${COLOR_MAGENTA}${MAGENTO_ADMIN_USER}${COLOR_RESET}

${COLOR_YELLOW}Admin User Default Password${COLOR_RESET}
${COLOR_MAGENTA}${MAGENTO_ADMIN_PASSWORD}${COLOR_RESET}

${COLOR_YELLOW}Admin Email${COLOR_RESET}
${COLOR_MAGENTA}${MAGENTO_ADMIN_EMAIL}${COLOR_RESET}

EOF

SERVICE_URLS=""
append_service_url() {
    local name="$1"
    local port="$2"

    if [ -n "$port" ]; then
        printf -v SERVICE_URLS '%s%s\n%s:%s\n\n' "$SERVICE_URLS" "${COLOR_YELLOW}${name}${COLOR_RESET}" "$SERVICE_URL_PREFIX" "$port"
    fi
}

append_service_url "RabbitMq" "${HOST_MACHINE_RABBIT_MQ_WEB_UI_PORT:-}"
append_service_url "OpenSearch Dashboard" "${HOST_MACHINE_OPENSEARCH_DASHBOARD_PORT:-}"
append_service_url "PHP MyAdmin" "${HOST_MACHINE_PHP_MY_ADMIN_WEB_UI_PORT:-}"
append_service_url "Redis Insight" "${HOST_MACHINE_REDIS_INSIGHT_PORT:-}"
append_service_url "Mailpit" "${HOST_MACHINE_MAILPIT_WEB_UI_PORT:-}"
append_service_url "Jenkins" "${HOST_MACHINE_JENKINS_WEB_UI_PORT:-}"

cat <<EOF

${COLOR_CYAN}${COLOR_BOLD}========================
ACCESSIBLE SERVICE URLs
========================${COLOR_RESET}

${SERVICE_URLS}
EOF

ok "Magento installation finished successfully"