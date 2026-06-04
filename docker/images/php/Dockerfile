FROM php:8.4-fpm

ARG app_user_id
ARG app_group_id

COPY conf/php.ini /usr/local/etc/php/

# Install system dependencies
RUN apt-get update && apt-get install -y \
    libfreetype-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libicu-dev \
    libxslt1-dev \
    sendmail \
    sudo \
    libzip-dev \
    libonig-dev \
    curl \
    libsodium-dev \
    libcurl4-openssl-dev \
    unzip \
    git \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Composer (after curl is available)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=2.8.6

# Configure the GD library
RUN docker-php-ext-configure gd --with-freetype --with-jpeg

# Install required PHP extensions
RUN docker-php-ext-install \
    dom \
    gd \
    intl \
    mbstring \
    pdo_mysql \
    xsl \
    zip \
    ftp \
    soap \
    bcmath \
    pcntl \
    sockets \
    opcache \
    ctype \
    fileinfo \
    filter \
    iconv \
    simplexml \
    sodium \
    xmlwriter

# Install Swoole extension
RUN pecl install swoole && \
    docker-php-ext-enable swoole && \
    echo "swoole.use_shortname=Off" >> /usr/local/etc/php/conf.d/docker-php-ext-swoole.ini

# Install Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Create app user and group
RUN groupadd -g ${app_group_id} app && \
    useradd -g ${app_group_id} -u ${app_user_id} -d /var/www -s /bin/bash app

# Ensure correct permissions
RUN chown -R app:app /var/www

USER app:app

VOLUME /var/www
WORKDIR /var/www/html