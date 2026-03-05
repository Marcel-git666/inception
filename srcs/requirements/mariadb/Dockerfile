# 1. Sticking to our chosen version of Alpine
FROM alpine:3.22

# 2. Install the database server and client
RUN apk update && apk add --no-cache mariadb mariadb-client

# 3. Create a directory for runtime files (sockets) needed by MariaDB
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# 4. Copy our configuration file
COPY conf/my.cnf /etc/my.cnf.d/mariadb-server.cnf

# 5. Copy and set executable permissions for the startup script
COPY tools/mariadb.sh /usr/local/bin/mariadb.sh
RUN chmod +x /usr/local/bin/mariadb.sh

# 6. MariaDB listens on port 3306 by default
EXPOSE 3306

# 7. Execute our script when the container starts
ENTRYPOINT ["/usr/local/bin/mariadb.sh"]