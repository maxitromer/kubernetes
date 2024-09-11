#!/bin/sh
set -e

# Run the original WordPress entrypoint script
/usr/local/bin/docker-entrypoint.sh php-fpm &

# Wait for PHP-FPM to start
sleep 5

# Start Nginx in the foreground
exec nginx -g 'daemon off;'