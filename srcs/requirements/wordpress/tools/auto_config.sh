#!/bin/sh

# 1. Navigate to the web root directory
cd /var/www/html

# 2. Check if WordPress is already configured to ensure idempotency
if [ ! -f "wp-config.php" ]; then
    echo "WordPress not found. Starting fresh installation..."

    # Download core WordPress files
    wp core download --allow-root

    # 3. Create wp-config.php with integrated Redis configuration
    # Using --extra-php ensures Redis constants are placed BEFORE wp-settings.php
    wp config create --dbname="${MYSQL_DATABASE}" \
                     --dbuser="${MYSQL_USER}" \
                     --dbpass="${MYSQL_PASSWORD}" \
                     --dbhost="mariadb" \
                     --extra-php <<PHP
define( 'WP_REDIS_HOST', 'redis' );
define( 'WP_REDIS_PORT', 6379 );
define( 'WP_CACHE', true );
PHP
                     --allow-root

    # 4. Install WordPress and set up the site and admin account
    wp core install --url="https://${DOMAIN_NAME}" \
                    --title="Inception 42" \
                    --admin_user="${WP_ADMIN_USER}" \
                    --admin_password="${WP_ADMIN_PASSWORD}" \
                    --admin_email="${WP_ADMIN_EMAIL}" \
                    --skip-email \
                    --allow-root

    # 5. Create a secondary non-admin user (required by subject)
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
                    --user_pass="${WP_USER_PASSWORD}" \
                    --role=author \
                    --allow-root

    # 6. Bonus: Install and enable Redis Object Cache plugin
    # This only runs if the 'redis' container is reachable in the network
    if getent hosts redis > /dev/null 2>&1; then
        echo "Redis detected. Activating Object Cache plugin..."
        wp plugin install redis-cache --activate --allow-root
        wp redis enable --allow-root
    fi

    echo "WordPress setup completed successfully!"
else
    echo "WordPress is already configured. Skipping installation."
fi

# 7. Set correct permissions for the web server
# 'nobody' is the standard user for NGINX/PHP-FPM in Alpine
chown -R nobody:nobody /var/www/html

# 8. Start PHP-FPM in foreground to keep the container alive
echo "Starting PHP-FPM..."
exec php-fpm83 -F