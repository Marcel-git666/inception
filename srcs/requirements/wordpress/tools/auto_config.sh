#!/bin/sh

# 1. Go to the WordPress web directory
cd /var/www/html

# 2. Check if WordPress is already installed
if [ ! -f "wp-config.php" ]; then
    echo "WordPress is not installed. Starting configuration..."

    # Download WordPress core files using WP-CLI
    wp core download --allow-root

    # Create the wp-config.php file using environment variables
    # Database connection uses internal Docker DNS 'mariadb'
    wp config create --dbname="${MYSQL_DATABASE}" \
                     --dbuser="${MYSQL_USER}" \
                     --dbpass="${MYSQL_PASSWORD}" \
                     --dbhost="mariadb" \
                     --allow-root

    # Install WordPress and set up the administrator account
    # CRITICAL: The admin username MUST NOT contain 'admin' or 'Admin'
    wp core install --url="https://${DOMAIN_NAME}" \
                    --title="Inception 42" \
                    --admin_user="${WP_ADMIN_USER}" \
                    --admin_password="${WP_ADMIN_PASSWORD}" \
                    --admin_email="${WP_ADMIN_EMAIL}" \
                    --skip-email \
                    --allow-root

    # Create a regular user for WordPress
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
                   --user_pass="${WP_USER_PASSWORD}" \
                   --role=author \
                   --allow-root

    echo "WordPress successfully configured!"
else
    echo "WordPress is already configured. Persistence check passed."
fi

# --- BONUS: DYNAMIC REDIS CONFIGURATION ---
if getent hosts redis > /dev/null; then
    echo "Redis container detected. Configuring Object Cache..."
    wp config set WP_REDIS_HOST redis --allow-root
    wp config set WP_REDIS_PORT 6379 --allow-root
    wp config set WP_CACHE true --raw --allow-root
    
    if ! wp plugin is-installed redis-cache --allow-root; then
        wp plugin install redis-cache --activate --allow-root
        wp redis enable --allow-root
    fi
else
    echo "Redis container not found. Skipping cache configuration."
fi

chown -R nobody:nobody /var/www/html

echo "Starting PHP-FPM in the foreground (PID 1)..."
# Using exec to replace the script with the PHP process
exec php-fpm83 -F