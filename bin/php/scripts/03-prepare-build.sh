#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PHP_BIN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
PROJECT_ROOT="$(cd "$PHP_BIN_DIR/../.." && pwd)"

source "$SCRIPT_DIR/common.sh"

BUILD_DIR="$PROJECT_ROOT/build"

if [[ ! -d "$BUILD_DIR" ]]; then
    info "Creating build directory"
    cp -R "$PROJECT_ROOT/build.sample" "$BUILD_DIR"
fi

cp \
    "$PROJECT_ROOT/docker/images/nginx/conf/generic.conf.sample" \
    "$PROJECT_ROOT/docker/images/nginx/conf/default.conf"

ok "Build preparation complete"