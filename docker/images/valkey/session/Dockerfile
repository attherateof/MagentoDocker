FROM valkey/valkey:8

# Ensure correct path for custom config
COPY conf/valkey.conf /usr/local/etc/valkey/valkey.conf

# Use CMD to start Valkey with custom config
CMD ["valkey-server", "/usr/local/etc/valkey/valkey.conf"]
