FROM alpine:3.22

# 1. Update and install PHP along with necessary extensions
# Adminer needs php-session to let you log in, and php-mysqli to talk to MariaDB.
RUN apk update && apk add --no-cache \
    php \
    php-session \
    php-mysqli \
    wget

# 2. Create the web directory
WORKDIR /var/www

# 3. Download the latest Adminer release and rename it to index.php
# Naming it index.php is crucial so the built-in PHP server picks it up automatically.
RUN wget https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php -O index.php

# 4. Download your chosen CSS theme (Hever)
RUN wget https://raw.githubusercontent.com/vrana/adminer/master/designs/hever/adminer.css -O adminer.css

# 5. Start the built-in PHP web server on port 8080
# The -t specifies the document root where our index.php lives.
CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www"]