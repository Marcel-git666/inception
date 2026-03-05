#!/bin/sh

# Check if the database already exists (to prevent overwriting it on container restart)
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing empty database..."
    # Create basic database structure (system tables)
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    echo "Creating user and database for WordPress..."
    # Create a temporary file with SQL commands
    cat << EOF > /tmp/init.sql
    FLUSH PRIVILEGES;
    
    -- Set password for the main root database user
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    
    -- Create database for WordPress
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    
    -- Create WordPress user and grant all privileges on its database
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    
    FLUSH PRIVILEGES;
EOF

    # Run the database in bootstrap mode, which executes our SQL commands and shuts down
    mysqld --user=mysql --bootstrap < /tmp/init.sql
    
    # Cleanup: remove the temporary file with passwords
    rm -f /tmp/init.sql
fi

echo "Starting main MariaDB process..."
# The --console parameter ensures logs go to the terminal and the process runs in the foreground.
# The exec command makes it the main container process (PID 1), fulfilling the strict requirements.
exec mysqld --user=mysql --console