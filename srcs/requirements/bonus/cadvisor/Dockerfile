# Using Alpine 3.22 as the penultimate stable version
FROM alpine:3.22

# Install dependencies
RUN apk update && apk add --no-cache curl gcompat

# Detect architecture and download the correct cAdvisor binary
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "x86_64" ]; then \
        CADVISOR_ARCH="amd64"; \
    elif [ "$ARCH" = "aarch64" ]; then \
        CADVISOR_ARCH="arm64"; \
    fi && \
    curl -L "https://github.com/google/cadvisor/releases/download/v0.49.1/cadvisor-v0.49.1-linux-${CADVISOR_ARCH}" -o /usr/bin/cadvisor && \
    chmod +x /usr/bin/cadvisor

# cAdvisor must run in the foreground 
EXPOSE 8080

CMD ["/usr/bin/cadvisor", "-logtostderr", "--port=8080"]