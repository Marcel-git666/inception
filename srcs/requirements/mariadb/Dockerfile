# 1. Stále se držíme naší zvolené verze Alpine [cite: 78]
FROM alpine:3.22

# 2. Instalace databázového serveru a klienta
RUN apk update && apk add --no-cache mariadb mariadb-client

# 3. Vytvoření složky pro běhové soubory (tzv. sockety), které MariaDB potřebuje
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# 4. Zkopírování našeho konfiguračního souboru
COPY conf/my.cnf /etc/my.cnf.d/mariadb-server.cnf

# 5. Zkopírování a nastavení práv pro spouštěcí skript
COPY tools/mariadb.sh /usr/local/bin/mariadb.sh
RUN chmod +x /usr/local/bin/mariadb.sh

# 6. MariaDB standardně naslouchá na portu 3306 [cite: 129]
EXPOSE 3306

# 7. Při spuštění kontejneru se zavolá náš skript
ENTRYPOINT ["/usr/local/bin/mariadb.sh"]