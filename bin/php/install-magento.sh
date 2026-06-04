#!/usr/bin/env bash
set -Eeuo pipefail

INSTALL_SAMPLE_DATA=false

for arg in "$@"; do
    case "$arg" in
        --sample-data)
            INSTALL_SAMPLE_DATA=true
            ;;
        *)
            echo "[ERROR] Unknown option: $arg"
            exit 1
            ;;
    esac
done

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/../.." && pwd)"

export INSTALL_SAMPLE_DATA
export PROJECT_ROOT
export SCRIPT_DIR

chmod +x "$SCRIPT_DIR"/scripts/*.sh

"$SCRIPT_DIR/scripts/01-load-env.sh"
"$SCRIPT_DIR/scripts/02-validate-env.sh"
"$SCRIPT_DIR/scripts/03-prepare-build.sh"
"$SCRIPT_DIR/scripts/04-set-nginx-config.sh"
"$SCRIPT_DIR/scripts/05-start-docker.sh"
"$SCRIPT_DIR/scripts/06-preflight-checks.sh"
"$SCRIPT_DIR/scripts/07-configure-composer.sh"
"$SCRIPT_DIR/scripts/08-install-magento.sh"

if [[ "$INSTALL_SAMPLE_DATA" == "true" ]]; then
    "$SCRIPT_DIR/scripts/09-sample-data.sh"
fi

"$SCRIPT_DIR/scripts/10-post-install.sh"
"$SCRIPT_DIR/scripts/11-nginx-switch.sh"
"$SCRIPT_DIR/scripts/12-restart-docker.sh"
"$SCRIPT_DIR/scripts/13-summary.sh"