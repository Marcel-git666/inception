# 1. Use the same Alpine version as NGINX
FROM alpine:3.22

# 2. Install PHP, PHP-FPM, and extensions required for WordPress and database communication
RUN apk update && apk add --no-cache \
    php \
    php-fpm \
    php-mysqli \
    php-phar \
    php-mbstring \
    php-iconv \
    php83-tokenizer \
    php83-ctype \
    curl \
    mariadb-client

RUN sed -i 's/memory_limit = 128M/memory_limit = 512M/g' /etc/php83/php.ini

# 3. Download the WP-CLI tool for automatic WordPress installation
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# 4. Create the directory where the website will physically reside
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

# 5. Copy the PHP-FPM configuration file
COPY conf/www.conf /etc/php83/php-fpm.d/www.conf

# 6. Copy our installation script and set execution permissions
COPY tools/auto_config.sh /usr/local/bin/auto_config.sh
RUN chmod +x /usr/local/bin/auto_config.sh

# 7. Expose port 9000, where PHP-FPM will listen for NGINX requests
EXPOSE 9000

# 8. Execute our script when the container starts
ENTRYPOINT ["/usr/local/bin/auto_config.sh"]