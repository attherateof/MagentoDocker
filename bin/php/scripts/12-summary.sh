#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PHP_BIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PHP_BIN_DIR/../.." && pwd)"

source "$SCRIPT_DIR/common.sh"
source "$SCRIPT_DIR/load-env.inc.sh"

ADMIN_URI=""
if [ -f "${PROJECT_ROOT}/build/app/etc/env.php" ]; then
    ADMIN_URI="$(grep -E "['\"]frontName['\"] *=> *['\"][^'\"]+['\"]" "${PROJECT_ROOT}/build/app/etc/env.php" | head -n1 | sed -E "s/.*['\"]frontName['\"] *=> *['\"]([^'\"]+)['\"].*/\1/")"
fi

if [ -n "${ADMIN_URI}" ]; then
    ADMIN_URL="${MAGENTO_BASE_URL}${ADMIN_URI}"
fi

cat <<EOF

========================
MAGENTO INSTALL COMPLETE
========================

Magento URL
${MAGENTO_BASE_URL}
EOF

if [ -n "${ADMIN_URI}" ]; then
cat <<EOF

Admin URL
${ADMIN_URL}
EOF
fi

cat <<EOF

Admin User
${MAGENTO_ADMIN_USER}

Admin Email
${MAGENTO_ADMIN_EMAIL}

========================

EOF

ok "Magento installation finished successfully"
