#!/bin/sh

# Go to the WordPress web directory (mapped via Docker Volumes)
cd /var/www/html

# Check if WordPress is already installed by looking for the configuration file
if [ ! -f "wp-config.php" ]; then
    echo "WordPress is not installed. Starting configuration..."

    # Download WordPress core files using WP-CLI
    wp core download --allow-root

    # Create the wp-config.php file using environment variables
    # The --dbhost connects to our database container via internal Docker DNS
    wp config create --dbname="${MYSQL_DATABASE}" \
                     --dbuser="${MYSQL_USER}" \
                     --dbpass="${MYSQL_PASSWORD}" \
                     --dbhost="mariadb" \
                     --allow-root

    # Install WordPress and set up the administrator account
    # [cite_start]Note: The admin username cannot contain 'admin' or 'administrator' [cite: 107]
    wp core install --url="https://${DOMAIN_NAME}" \
                    --title="Inception 42" \
                    --admin_user="${WP_ADMIN_USER}" \
                    --admin_password="${WP_ADMIN_PASSWORD}" \
                    --admin_email="${WP_ADMIN_EMAIL}" \
                    --skip-email \
                    --allow-root

    # Create a regular user (e.g., an author) for WordPress
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
                   --user_pass="${WP_USER_PASSWORD}" \
                   --role=author \
                   --allow-root

    echo "WordPress successfully configured!"
else
    echo "WordPress is already configured. Skipping installation..."
fi

echo "Starting PHP-FPM in the foreground..."
# The exec command replaces the shell script with the PHP-FPM process (making it PID 1)
# The -F flag forces PHP-FPM to run in the foreground instead of as a daemon, which is required for Docker containers.
exec php-fpm83 -F