# 1. Using Alpine 3.22 as the penultimate stable version
FROM alpine:3.22

# 2. Install redis
RUN apk update && apk add --no-cache redis

# 3. Configure Redis to listen on all interfaces (not just localhost)
# and disable protected mode so WordPress can connect from its own container
RUN sed -i "s|bind 127.0.0.1|bind 0.0.0.0|g" /etc/redis.conf && \
    sed -i "s|protected-mode yes|protected-mode no|g" /etc/redis.conf

# 4. Standard Redis port
EXPOSE 6379

# 5. Run redis-server in the foreground
CMD ["redis-server", "/etc/redis.conf"]