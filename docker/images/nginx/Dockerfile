FROM nginx:1.26

ARG app_user_id
ARG app_group_id

# Create user and group for app
RUN groupadd -g ${app_group_id} app && useradd -g ${app_group_id} -u ${app_user_id} -d /var/www -s /bin/bash app

# Create necessary directories
RUN mkdir -p /var/www/html /sock /etc/nginx/certs /var/log/nginx && touch /var/run/nginx.pid

# Install dependencies
RUN apt-get update && apt-get install -y openssl curl && rm -rf /var/lib/apt/lists/*

# Generate self-signed SSL certificate
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/certs/nginx.key \
    -out /etc/nginx/certs/nginx.crt \
    -subj "/CN=localhost"

# Set permissions
RUN chown -R app:app /etc/nginx/certs/* /var/cache/nginx/ /var/run/nginx.pid /sock /var/log/nginx

# Copy Nginx configuration
COPY ./conf/default.conf /etc/nginx/conf.d/

# Use non-root user after setup
USER app:app

VOLUME /var/www
WORKDIR /var/www/html
