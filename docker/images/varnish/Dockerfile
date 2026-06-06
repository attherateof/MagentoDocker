FROM varnish:7.6.0

COPY --chmod=755 entrypoint.sh /entrypoint.sh

# Run as root so entrypoint can fix permissions
USER root

ENTRYPOINT ["/entrypoint.sh"]
