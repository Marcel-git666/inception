#!/bin/sh

# 1. Přejdeme do složky, kde má web ležet
cd /var/www/html

# 2. Zkontrolujeme, jestli už není WordPress nainstalovaný
if [ ! -e wp-config.php ]; then
    echo "Stahuji jádro WordPressu..."
    wp core download --allow-root

    echo "Vytvářím konfigurační soubor pro připojení k databázi..."
    wp config create --dbname=$MYSQL_DATABASE \
                     --dbuser=$MYSQL_USER \
                     --dbpass=$MYSQL_PASSWORD \
                     --dbhost=mariadb:3306 \
                     --allow-root

    echo "Instaluji WordPress..."
    # Zde projekt vyžaduje vytvoření administrátora, jehož jméno nesmí obsahovat slovo admin/administrator [cite: 106, 107]
    wp core install --url=$DOMAIN_NAME \
                    --title="Inception mmravec" \
                    --admin_user=$WP_ADMIN_USER \
                    --admin_password=$WP_ADMIN_PASSWORD \
                    --admin_email=$WP_ADMIN_EMAIL \
                    --allow-root

    echo "Vytvářím druhého, běžného uživatele..."
    # Projekt vyžaduje, aby v databázi byli dva uživatelé [cite: 106]
    wp user create $WP_USER $WP_USER_EMAIL --role=author --user_pass=$WP_USER_PASSWORD --allow-root

    # Nastavení správných práv pro webový server v Alpine Linuxu
    chown -R nobody:nobody /var/www/html
fi

echo "WordPress je připraven! Spouštím PHP-FPM..."
# Spuštění php-fpm na popředí. V Alpine 3.20/3.22 je binárka pojmenována php-fpm83. 
# Příznak -F zajistí běh na popředí, abychom nepoužili zakázané "hacky" typu tail -f[cite: 97, 104].
# Příkaz exec zajistí, že se tento proces stane hlavním procesem kontejneru (PID 1)[cite: 105].
exec php-fpm83 -F