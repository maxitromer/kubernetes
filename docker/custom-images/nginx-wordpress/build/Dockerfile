ARG WORDPRESS_VERSION=6.6.2
ARG PHP_VERSION=8.3
ARG LUDICROUSDB_VERSION=5.2.0
# ARG W3TC_VERSION=2.7.5
ARG WP_DIR=/var/www/html
ARG WP_CONTENT_DIR=/var/www/html/wp-content

# Use the official WordPress image as the base
FROM wordpress:${WORDPRESS_VERSION}-php${PHP_VERSION}-fpm-alpine

# Pass ARGs to the final stage
ARG WORDPRESS_VERSION
ARG PHP_VERSION
ARG LUDICROUSDB_VERSION
# ARG W3TC_VERSION
ARG WP_DIR
ARG WP_CONTENT_DIR
# Install necessary packages and build dependencies
RUN apk add --no-cache \
    libmemcached-dev \
    nginx \
    nginx-mod-http-cache-purge \
    autoconf \
    g++ \
    zlib-dev \
    wget \
    unzip \
    make \
    redis

# Add these lines to install phpredis
RUN pecl install redis && \
    docker-php-ext-enable redis

# Install LudicrousDB and W3 Total Cache plugins, remove default plugins
RUN wget https://github.com/stuttter/ludicrousdb/archive/refs/tags/${LUDICROUSDB_VERSION}.zip -O /tmp/ludicrousdb.zip \
    && unzip /tmp/ludicrousdb.zip -d ${WP_CONTENT_DIR}/plugins/ \
    && mv ${WP_CONTENT_DIR}/plugins/ludicrousdb-${LUDICROUSDB_VERSION} ${WP_CONTENT_DIR}/plugins/ludicrousdb \
    && rm /tmp/ludicrousdb.zip \
    # && wget https://downloads.wordpress.org/plugin/w3-total-cache.${W3TC_VERSION}.zip -O /tmp/w3-total-cache.zip \
    # && unzip /tmp/w3-total-cache.zip -d ${WP_CONTENT_DIR}/plugins/ \
    # && rm /tmp/w3-total-cache.zip \
    && rm -rf /tmp/*

# Install and enable memcached extension
RUN pecl install memcached \
    && docker-php-ext-enable memcached

# Clean up build dependencies
RUN apk del autoconf g++ make wget unzip 

# Copy custom nginx configuration file
COPY build/default.conf /etc/nginx/http.d/default.conf

# Configure LudicrousDB drop-ins
RUN cp ${WP_CONTENT_DIR}/plugins/ludicrousdb/ludicrousdb/drop-ins/db.php ${WP_CONTENT_DIR}/db.php \
    && cp ${WP_CONTENT_DIR}/plugins/ludicrousdb/ludicrousdb/drop-ins/db-error.php ${WP_CONTENT_DIR}/db-error.php
    # && cp ${WP_CONTENT_DIR}/plugins/ludicrousdb/ludicrousdb/drop-ins/db-config.php ${WP_DIR}/db-config.php

# Remove the WP pre-installed plugins    
# RUN rm -rf /var/www/html/wp-content/plugins/akismet \
#     && rm /var/www/html/wp-content/plugins/hello.php

# Copy custom db-config.php (if you have a custom one)
COPY db-config.php ${WP_DIR}/db-config.php

# # https://medium.com/@musechan88/w3-total-cache-work-with-hyperdb-c883d14e1649
# # Set up W3 Total Cache to work with ludicrousdb
# RUN cp ${WP_CONTENT_DIR}/plugins/w3-total-cache/wp-content/db.php ${WP_CONTENT_DIR}/db-cache.php \
#     && sed -i "/define( 'W3TC_INSTALL_FILE_DB', W3TC_INSTALL_DIR . '\/db.php' );/s/db.php/db-cache.php/" ${WP_CONTENT_DIR}/plugins/w3-total-cache/w3-total-cache-api.php \
#     && sed -i "/define( 'W3TC_ADDIN_FILE_DB', WP_CONTENT_DIR . '\/db.php' );/s/db.php/db-cache.php/" ${WP_CONTENT_DIR}/plugins/w3-total-cache/w3-total-cache-api.php


# Create a custom entrypoint script
COPY build/entrypoint.sh /usr/local/bin/custom-entrypoint.sh
RUN chmod +x /usr/local/bin/custom-entrypoint.sh

# Set the custom entrypoint
ENTRYPOINT ["/usr/local/bin/custom-entrypoint.sh"]
CMD ["php-fpm"]