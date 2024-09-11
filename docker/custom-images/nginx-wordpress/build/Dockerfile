# Use the official WordPress image as the base
FROM wordpress:6.6.1-php8.3-fpm-alpine

# Install necessary packages and build dependencies
RUN apk add --no-cache \
    libmemcached-dev \
    nginx \
    nginx-mod-http-cache-purge \
    autoconf \
    g++ \
    zlib-dev \
    make

# Install and enable memcached extension
RUN pecl install memcached \
    && docker-php-ext-enable memcached

# Clean up build dependencies
RUN apk del autoconf g++ make

# Copy custom nginx configuration file
COPY build/default.conf /etc/nginx/http.d/default.conf

# Create a custom entrypoint script
COPY build/entrypoint.sh /usr/local/bin/custom-entrypoint.sh
RUN chmod +x /usr/local/bin/custom-entrypoint.sh

# Set the custom entrypoint
ENTRYPOINT ["/usr/local/bin/custom-entrypoint.sh"]
CMD ["php-fpm"]