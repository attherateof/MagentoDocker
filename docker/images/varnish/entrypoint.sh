#!/bin/sh
set -e

chown -R varnish:varnish /var/lib/varnish

exec /usr/local/bin/docker-varnish-entrypoint "$@"
