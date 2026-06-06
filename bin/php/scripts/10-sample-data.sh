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

docker_exec_php "
    cd /var/www/html

    modules_to_enable=''

    for module in \
        Magento_ConfigurableSampleData \
        Magento_ReviewSampleData \
        Magento_OfflineShippingSampleData \
        Magento_CatalogRuleSampleData \
        Magento_TaxSampleData \
        Magento_SalesRuleSampleData \
        Magento_SwatchesSampleData \
        Magento_MsrpSampleData \
        Magento_CustomerSampleData \
        Magento_CmsSampleData \
        Magento_SalesSampleData \
        Magento_ProductLinksSampleData \
        Magento_WidgetSampleData \
        Magento_WishlistSampleData \
        Magento_SampleData \
        Magento_CatalogSampleData \
        Magento_BundleSampleData \
        Magento_GroupedProductSampleData \
        Magento_DownloadableSampleData \
        Magento_ThemeSampleData
    do
        if php bin/magento module:status \"\$module\" 2>/dev/null | grep -q 'Module is disable'; then
            modules_to_enable=\"\$modules_to_enable \$module\"
        fi
    done

    if [ -n \"\$modules_to_enable\" ]; then
        php bin/magento --no-interaction module:enable \$modules_to_enable
    fi
"