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