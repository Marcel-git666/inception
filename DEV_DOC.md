# Developer Documentation

This document details how a developer can set up, manage, and understand the technical architecture of this project.

## Setting Up the Environment from Scratch

### 1. Prerequisites
* A Linux environment (e.g., Ubuntu Virtual Machine).
* Docker and Docker Compose installed.
* `make` installed.

### 2. Local DNS Configuration
To route the required domain to your local machine, edit the host's `/etc/hosts` file (requires `sudo`):
`127.0.0.1    mmravec.42.fr`

### 3. Configuration and Secrets
Create a `.env` file inside the `srcs/` folder. This file is excluded from Git tracking via `.gitignore`. Add the following variables:

```env
DOMAIN_NAME=mmravec.42.fr
MYSQL_ROOT_PASSWORD=your_root_pass
MYSQL_DATABASE=wordpress_db
MYSQL_USER=wp_user
MYSQL_PASSWORD=your_db_pass
WP_ADMIN_USER=mmravec_boss
WP_ADMIN_PASSWORD=your_admin_pass
WP_ADMIN_EMAIL=mmravec@student.42.fr
WP_USER=author_user
WP_USER_EMAIL=author@42.fr
WP_USER_PASSWORD=your_author_pass
```

## Project Architecture & Routing
This project uses a custom Docker bridge network (`inception`) to allow internal container resolution via Docker's embedded DNS. Containers communicate using their service names instead of static IP addresses.

### Core Services (`docker-compose.yml`)
* **NGINX:** The only service exposing a port (443) to the host network. It terminates SSL/TLS and routes traffic based on the URI.
* **WordPress (PHP-FPM):** Processes dynamic PHP scripts. NGINX routes `~ \.php$` requests here via FastCGI on port 9000.
* **MariaDB:** Operates on port 3306 internally. It is strictly isolated and only accessible by the WordPress and Adminer containers.

### Bonus Services (`docker-compose-bonus.yml`)
* **Lighttpd (Static Web):** A lightweight web server running on Alpine, exposing port 3000 internally.
  * *Routing:* NGINX acts as a reverse proxy. Any request to `^~ /bonus` is proxied to `http://lighttpd:3000/`.
  * *Deployment Strategy:* The static HTML/CSS files are baked directly into the image using the `COPY` instruction in the Dockerfile, ensuring a stateless and highly portable container.
* **Adminer:** A standalone database management tool exposed on host port 8080.
  * *Deployment Strategy:* To maintain a clean repository according to 42 school norms, the PHP script is not stored locally. Instead, it is dynamically downloaded via `wget` during the image build process.
* **Redis Cache:** An in-memory key-value store running on internal port 6379.
  * *Integration Strategy:* The WordPress container dynamically checks for the presence of the Redis host during its setup phase. If found, it automatically installs the `redis-cache` plugin via WP-CLI and routes object cache requests to this container.
* **FTP Server (vsftpd):** Exposes port 21 for command traffic and a specific range of ports (30000-30009) for passive data transfer mode.
  * *Deployment Strategy:* A custom initialization script executes on startup to create a local Alpine user using the credentials from `.env`. This user is then granted ownership over the shared WordPress volume (`/var/www/html`) to allow direct file manipulation.
* **cAdvisor:** A container resource monitoring tool exposed on host port 8081.
  * *Deployment Strategy:* The Dockerfile uses a shell script block to detect the host machine's architecture (`amd64` vs `arm64`) and downloads the appropriate binary release via `curl`. It requires root privileges and specific read-only volume mounts (`/`, `/var/run`, `/sys`, `/var/lib/docker`) to securely read the Docker daemon's metrics.
  
## Useful Developer Commands
* `docker compose -f srcs/docker-compose-bonus.yml logs -f`: Tail the logs of all running containers in real-time.
* `docker exec -it <container_name> /bin/sh`: Open an interactive shell inside a running Alpine container for debugging.
* `docker network inspect inception`: Verify container IP assignments and internal DNS records.