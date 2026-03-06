# 1. Using the penultimate stable version of Alpine
FROM alpine:3.22

# 2. Install lighttpd 
RUN apk update && apk add --no-cache lighttpd

# 3. Create a directory for lighttpd runtime files
RUN mkdir -p /run/lighttpd

# 4. Copy our custom configuration into the container
COPY conf/lighttpd.conf /etc/lighttpd/lighttpd.conf

# 5. Copy your static website files into the container's web directory
COPY conf/website/ /var/www/html/

# 6. Expose port 3000 for internal Docker network communication
EXPOSE 3000

# 7. Run in the foreground (-D) and point to the config file (-f)
CMD ["lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]