#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PHP_BIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PHP_BIN_DIR/../.." && pwd)"

source "$SCRIPT_DIR/common.sh"
source "$SCRIPT_DIR/load-env.inc.sh"

MAGENTO_DEPLOY_MODE="$(printf '%s' "${MAGENTO_MODE:-developer}" | tr '[:upper:]' '[:lower:]')"

case "$MAGENTO_DEPLOY_MODE" in
    default|developer|production) ;;
    *) MAGENTO_DEPLOY_MODE="developer" ;;
esac

info "Running Magento post-install tasks"

if [[ "$MAGENTO_DEPLOY_MODE" != "production" ]]; then
    info "Disabling Magento two-factor authentication for non production mode"

    docker_exec_php "
    cd /var/www/html

    modules_to_disable=''
    for module in Magento_AdminAdobeImsTwoFactorAuth Magento_TwoFactorAuth; do
        if php bin/magento module:status \"\$module\" 2>/dev/null | grep -q 'Module is enabled'; then
            modules_to_disable=\"\$modules_to_disable \$module\"
        fi
    done

    if [ -n \"\$modules_to_disable\" ]; then
        php bin/magento --no-interaction module:disable \$modules_to_disable
    fi
"
fi

docker_exec_php "
cd /var/www/html

php bin/magento setup:upgrade
php bin/magento deploy:mode:set '${MAGENTO_DEPLOY_MODE}'
php bin/magento indexer:reindex
php bin/magento cache:flush
"

ok "Magento post-install tasks completed"
