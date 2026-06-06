FROM node:20.9.0

ARG app_user_id
ARG app_group_id

# Create app user and group (be tolerant if UID/GID already exist)
RUN set -eux; \
	groupadd -g ${app_group_id} app 2>/dev/null || true; \
	useradd -g ${app_group_id} -u ${app_user_id} -d /var/www -s /bin/bash app 2>/dev/null || true

# Set the working directory
WORKDIR /var/www/html

# Install Yarn if it does not exist
RUN if [ ! -f /usr/local/bin/yarn ]; then npm install -g yarn; fi

# Install dependencies (if any)
RUN yarn install || true

# Ensure correct permissions (use numeric uid:gid to work even if 'app' user wasn't created)
RUN chown -R ${app_user_id}:${app_group_id} /var/www || true

# Use non-root user (numeric ids work even if username doesn't exist)
USER ${app_user_id}:${app_group_id}

# Use the entrypoint script
CMD ["tail", "-f", "/dev/null"]