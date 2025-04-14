FROM node:20.9.0

ARG app_user_id
ARG app_group_id

# Create app user and group
RUN groupadd -g ${app_group_id} app && useradd -g ${app_group_id} -u ${app_user_id} -d /var/www -s /bin/bash app

# Set the working directory
WORKDIR /var/www/html

# Install Yarn if it does not exist
RUN if [ ! -f /usr/local/bin/yarn ]; then npm install -g yarn; fi

# Install dependencies (if any)
RUN yarn install || true

# Ensure correct permissions
RUN chown -R app:app /var/www

# Use non-root user
USER app:app

# Expose the port the app runs on
EXPOSE 3000

# Use the entrypoint script
CMD ["tail", "-f", "/dev/null"]