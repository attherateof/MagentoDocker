FROM php:8.4-fpm

ARG app_user_id
ARG app_group_id

COPY conf/php.ini /usr/local/etc/php/

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=2.8.6

# Update package lists and install dependencies in one step
RUN apt-get update && apt-get install -y \
    libfreetype-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libicu-dev \
    libxslt1-dev \
    sendmail-bin \
    sendmail \
    sudo \
    libzip-dev \
    libonig-dev \
    curl \
    libsodium-dev \
    libcurl4-openssl-dev \
    libpcre3-dev \
    unzip \
    git \
    libssl-dev \
    && rm -rf /var/lib/apt/lists/*

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

RUN docker-php-ext-enable \
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
    xmlwriter \
    xsl

# Install Xdebug
RUN pecl install xdebug && docker-php-ext-enable xdebug

# Create app user and group
RUN groupadd -g ${app_group_id} app && useradd -g ${app_group_id} -u ${app_user_id} -d /var/www -s /bin/bash app

# Ensure correct permissions
RUN chown -R app:app /var/www

# Use non-root user
USER app:app

VOLUME /var/www
WORKDIR /var/www/html