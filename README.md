*This project has been created as part of the 42 curriculum by mmravec.*

## Description
This project aims to broaden my knowledge of system administration by virtualizing a complete web infrastructure using Docker. The goal is to set up a small network of interconnected services running in separate containers, built from Alpine Linux. 

The core infrastructure consists of:
* **NGINX**: A web server acting as a secure entry point (HTTPS/TLSv1.2+ only).
* **WordPress + PHP-FPM**: The content management system generating dynamic web pages.
* **MariaDB**: The relational database storing WordPress data.

### Bonus Features
In addition to the mandatory part, this project includes several extra services:
* **Lighttpd**: A lightweight web server serving a custom static HTML/CSS website (my resume). It is accessible via a reverse proxy configured within the main NGINX container.
* **Adminer**: A database management tool running in its own container. To maintain a clean repository, the Adminer PHP script is downloaded dynamically via `wget` during the image build process.
* **Redis Cache**: A Redis container serving as an object cache for WordPress. The WordPress setup script dynamically installs and configures the Redis plugin via WP-CLI to significantly improve page load performance.
* **FTP Server (vsftpd)**: A Very Secure FTP Daemon pointing directly to the WordPress volume (`/var/www/html`). It allows the specified user to upload, download, or modify website files remotely. It is strictly configured with passive mode to work flawlessly across the Docker network bridge.
* **cAdvisor**: A monitoring daemon by Google that collects, aggregates, processes, and exports information about running containers. It provides a real-time web UI dashboard for tracking resource usage (CPU, memory, network traffic) of the entire infrastructure.

The design relies entirely on Docker Compose to orchestrate the containers, ensuring they communicate via an isolated internal network while persisting data securely on the host machine using localized Docker Volumes (bind mounts).

## Instructions
To build and execute this project, follow these steps:
1. Ensure your host machine resolves `mmravec.42.fr` to `127.0.0.1` (or your VM's IP) in the `/etc/hosts` file.
2. Create a `.env` file inside the `srcs/` directory containing the necessary credentials (see `DEV_DOC.md` for the template).
3. Run `make` in the root directory to build and start the core infrastructure. Alternatively, run `make bonus` to include the bonus services.
4. Access the services via your browser or client:
   * **Main Website (WordPress)**: `https://mmravec.42.fr`
   * **Static Website (Bonus)**: `https://mmravec.42.fr/bonus/`
   * **Adminer (Bonus)**: `http://localhost:8080` (or replace `localhost` with your VM's IP). *Use `mariadb` as the server name when logging in.*
   * **cAdvisor (Bonus)**: `http://localhost:8081` (or replace `localhost` with your VM's IP).
   * **FTP Server (Bonus)**: Connect using an FTP client (e.g., FileZilla) to `localhost` (or your VM's IP) on port `21`, using the FTP credentials defined in your `.env` file.

**Useful Makefile commands:**
* `make`: Builds and starts the core infrastructure.
* `make bonus`: Builds and starts the infrastructure including the bonus containers.
* `make down`: Stops the containers without deleting data.
* `make clean`: Stops containers, removes networks, volumes, and local images.
* `make fclean`: Fully wipes the system, including local physical data volumes, for a completely fresh start.

## Resources
* **Official Documentation**: Docker, Docker Compose, Alpine Linux, NGINX, WordPress WP-CLI, MariaDB, Lighttpd, Redis, vsftpd, cAdvisor.
* **AI Usage**: Artificial Intelligence (LLM) was used as a learning assistant throughout this project. I used it to understand complex concepts (like Docker internal DNS, FastCGI routing, Reverse Proxies, and PID 1 management), to debug errors (e.g., WordPress memory limits), and to structure these Markdown documentation files. All generated code was thoroughly reviewed, tested, and rewritten to ensure complete understanding before implementation.

## Technical Choices & Comparisons

### Virtual Machines vs Docker
Virtual Machines (VMs) virtualize an entire hardware stack, meaning each VM runs its own full operating system (Guest OS), making them heavy and slow to start. Docker, on the other hand, uses containerization. Containers share the host machine's OS kernel and only virtualize the application layer and its dependencies. This makes Docker lightweight, fast, and highly portable.

### Secrets vs Environment Variables
Environment variables (`.env` files) are widely used for passing configuration to containers, but they are injected as plain text and can be exposed if the container is compromised or logs are leaked. Docker Secrets provide a much more secure alternative: the sensitive data is encrypted at rest and only mounted in a temporary, in-memory filesystem (tmpfs) inside the container that specifically requests it, keeping it out of the general environment space.

### Docker Network vs Host Network
Using the Host Network binds the container directly to the host machine's network interface, bypassing Docker's network isolation (essentially removing the firewall). In this project, we use an isolated Docker Network (a bridge). This creates a private network where containers can securely resolve each other via internal DNS (e.g., `wordpress` pinging `mariadb`), and only the NGINX port 443 is explicitly exposed to the outside world.

### Docker Volumes vs Bind Mounts
Bind Mounts hardcode a specific path from the host machine directly into the container. This depends heavily on the host's directory structure and permissions, making it less portable. Docker Volumes are managed entirely by the Docker daemon in a secure area of the host filesystem (`/var/lib/docker/volumes/`). They are easier to back up, more secure, and guarantee consistent behavior across different host operating systems.