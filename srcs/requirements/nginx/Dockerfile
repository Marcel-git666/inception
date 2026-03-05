# 1. Using the penultimate stable version of Alpine
FROM alpine:3.22

# 2. Install NGINX and OpenSSL
RUN apk update && apk add --no-cache nginx openssl

# 3. Create a directory for the certificates
RUN mkdir -p /etc/nginx/ssl

# 4. Generate the certificate (customized for your mmravec login)
RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=CZ/ST=JM/L=Brno/O=42/OU=42/CN=mmravec.42.fr/UID=mmravec"

# 5. Create a directory for NGINX runtime files
RUN mkdir -p /run/nginx

# 6. Copy our custom configuration into the container
COPY conf/nginx.conf /etc/nginx/nginx.conf

# 7. Expose only port 443
EXPOSE 443

# 8. Run in the foreground so the container doesn't die
CMD ["nginx", "-g", "daemon off;"]