# 1. Použijeme stejnou verzi Alpine jako u NGINXu
FROM alpine:3.22

# 2. Instalace PHP, PHP-FPM a rozšíření potřebných pro WordPress a komunikaci s databází
RUN apk update && apk add --no-cache \
    php \
    php-fpm \
    php-mysqli \
    php-phar \
    php-mbstring \
    php-iconv \
    curl \
    mariadb-client

RUN sed -i 's/memory_limit = 128M/memory_limit = 512M/g' /etc/php83/php.ini

# 3. Stažení nástroje WP-CLI pro automatickou instalaci WordPressu
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# 4. Vytvoření složky, kde bude web fyzicky ležet
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

# 5. Zkopírování konfiguračního souboru pro PHP-FPM (vytvoříme v dalším kroku)
COPY conf/www.conf /etc/php83/php-fpm.d/www.conf

# 6. Zkopírování našeho instalačního skriptu a nastavení práv ke spuštění
COPY tools/auto_config.sh /usr/local/bin/auto_config.sh
RUN chmod +x /usr/local/bin/auto_config.sh

# 7. Otevření portu 9000, na kterém bude php-fpm poslouchat NGINX
EXPOSE 9000

# 8. Spuštění našeho skriptu při startu kontejneru
ENTRYPOINT ["/usr/local/bin/auto_config.sh"]