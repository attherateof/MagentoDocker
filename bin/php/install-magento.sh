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

LOGSTASH_PIPELINE_DIR="$PROJECT_ROOT/docker/images/logstash/pipeline"
LOGSTASH_CONF_SAMPLE="$LOGSTASH_PIPELINE_DIR/magento.conf.sample"
LOGSTASH_CONF="$LOGSTASH_PIPELINE_DIR/magento.conf"

if [[ ! -f "$LOGSTASH_CONF_SAMPLE" ]]; then
    echo "[ERROR] $LOGSTASH_CONF_SAMPLE not found"
    exit 1
fi
cp -f "$LOGSTASH_CONF_SAMPLE" "$LOGSTASH_CONF"

echo "[INFO] Logstash pipeline config copied to $LOGSTASH_CONF"

VARNISH_VCL="$PROJECT_ROOT/docker/images/varnish/varnish.vcl"
if [[ ! -f "$VARNISH_VCL" ]]; then
    echo "[ERROR] Varnish VCL not found at $VARNISH_VCL"
    exit 1
fi

echo "[INFO] Varnish VCL is present"

"$SCRIPT_DIR/scripts/01-load-env.sh"
"$SCRIPT_DIR/scripts/02-validate-env.sh"
"$SCRIPT_DIR/scripts/03-prepare-build.sh"
"$SCRIPT_DIR/scripts/04-set-nginx-config.sh"

"$SCRIPT_DIR/scripts/05-docker-build.sh"
"$SCRIPT_DIR/scripts/06-docker-up.sh"

echo "[SUCCESS] Containers started"

"$SCRIPT_DIR/scripts/07-preflight-checks.sh"
"$SCRIPT_DIR/scripts/08-configure-composer.sh"

"$SCRIPT_DIR/scripts/09-install-magento.sh"

if [[ "$INSTALL_SAMPLE_DATA" == "true" ]]; then
    "$SCRIPT_DIR/scripts/10-sample-data.sh"
fi

"$SCRIPT_DIR/scripts/11-post-install.sh"
"$SCRIPT_DIR/scripts/varnish-setup.sh"
"$SCRIPT_DIR/scripts/mailpit-setup.sh"
"$SCRIPT_DIR/scripts/12-nginx-switch.sh"
"$SCRIPT_DIR/scripts/13-restart-docker.sh"
"$SCRIPT_DIR/scripts/14-summary.sh"
