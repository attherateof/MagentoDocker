#!/bin/bash

# Exit if any command fails
set -e

# Set the directory to analyze (default: current directory)
TARGET_DIR=${1:-$(pwd)}

# Define Docker container name
DOCKER_CONTAINER="m246-php-fpm-1"

# Function to check if command exists inside Docker
check_command() {
    docker exec -it $DOCKER_CONTAINER bash -c "command -v $1 >/dev/null 2>&1"
}

# Check if Docker container is running
if ! docker ps --format '{{.Names}}' | grep -q "$DOCKER_CONTAINER"; then
    echo "❌ Error: Docker container '$DOCKER_CONTAINER' is not running."
    exit 1
fi

echo "🔍 Running code analysis for: $TARGET_DIR"
echo "-------------------------------------"

# Run PHP_CodeSniffer (PHPCS)
# if check_command "phpcs"; then
    # echo "🚀 Running PHPCS..."
    # docker exec -it $DOCKER_CONTAINER bash -c "vendor/bin/phpcs --standard=Magento2 $TARGET_DIR"
# else
#     echo "⚠️ PHPCS not found inside the container."
# fi

# Run PHP Mess Detector (PHPMD)
# if check_command "phpmd"; then
    echo "🚀 Running PHPMD..."
    docker exec -it $DOCKER_CONTAINER bash -c "vendor/bin/phpmd $TARGET_DIR text cleancode,codesize,controversial,design,naming,unusedcode"
# else
#     echo "⚠️ PHPMD not found inside the container."
# fi

# Run PHPStan (Static Analysis)
# if check_command "phpstan"; then
    echo "🚀 Running PHPStan..."
    docker exec -it $DOCKER_CONTAINER bash -c "vendor/bin/phpstan analyse $TARGET_DIR --level=7"
# else
#     echo "⚠️ PHPStan not found inside the container."
# fi

echo "✅ Code analysis completed!"
