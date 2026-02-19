# 1. Použití předposlední stabilní verze Alpine [cite: 78]
FROM alpine:3.22

# 2. Instalace NGINX a OpenSSL
RUN apk update && apk add --no-cache nginx openssl

# 3. Vytvoření složky pro certifikáty
RUN mkdir -p /etc/nginx/ssl

# 4. Generování certifikátu (upraveno pro tvůj login mmravec) 
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=CZ/ST=JM/L=Brno/O=42/OU=42/CN=mmravec.42.fr/UID=mmravec"

# 5. Vytvoření složky pro běhové soubory NGINXu
RUN mkdir -p /run/nginx

# 6. Zkopírování naší vlastní konfigurace do kontejneru
COPY conf/nginx.conf /etc/nginx/nginx.conf

# 7. Zveřejnění pouze portu 443 [cite: 120]
EXPOSE 443

# 8. Spuštění na popředí, aby kontejner neumřel [cite: 102-104]
CMD ["nginx", "-g", "daemon off;"]