#!/bin/sh

# Zkontrolujeme, jestli už databáze neexistuje (abychom ji při restartu kontejneru nepřemazali)
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Inicializuji prázdnou databázi..."
    # Vytvoření základní struktury databáze (systémové tabulky)
    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    echo "Vytvářím uživatele a databázi pro WordPress..."
    # Vytvoříme si dočasný soubor s SQL příkazy
    cat << EOF > /tmp/init.sql
    FLUSH PRIVILEGES;
    
    -- Nastavení hesla pro hlavního root uživatele databáze
    ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
    
    -- Vytvoření databáze pro WordPress
    CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
    
    -- Vytvoření uživatele pro WordPress a udělení všech práv k jeho databázi
    CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';
    
    FLUSH PRIVILEGES;
EOF

    # Spustíme databázi v tzv. bootstrap módu, který jen provede naše SQL příkazy a zase se vypne
    mysqld --user=mysql --bootstrap < /tmp/init.sql
    
    # Úklid: smažeme dočasný soubor s hesly
    rm -f /tmp/init.sql
fi

echo "Spouštím hlavní proces MariaDB..."
# Parametr --console zajistí, že logy půjdou do terminálu a proces poběží na popředí.
# Příkaz exec z něj udělá hlavní proces kontejneru (PID 1), čímž splníme přísná pravidla[cite: 105].
exec mysqld --user=mysql --console