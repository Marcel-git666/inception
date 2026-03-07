# User Documentation

This document explains how to interact with the Inception project as an end user or administrator.

## Services Provided
This infrastructure provides a fully functional, secure web stack, along with several additional bonus services:
1.  **Web Server (NGINX)**: Handles secure HTTPS connections from your browser.
2.  **Website (WordPress)**: A ready-to-use Content Management System where you can publish articles.
3.  **Database (MariaDB)**: A backend storage system holding your WordPress content and user accounts.
4.  **Static Website (Lighttpd)** *(Bonus)*: A lightweight web server hosting a custom HTML/CSS resume.
5.  **Database Manager (Adminer)** *(Bonus)*: A web-based graphical interface for managing the MariaDB database.
6.  **Redis Cache** *(Bonus)*: An in-memory data structure store used as an object cache to speed up the WordPress website.
7.  **FTP Server (vsftpd)** *(Bonus)*: A secure file transfer protocol server allowing remote access to the WordPress web directory.
8.  **Monitoring (cAdvisor)** *(Bonus)*: A real-time dashboard displaying container resource usage and performance metrics.

## Starting and Stopping the Project
Open a terminal in the root directory of the project:
* **To start the core project:** Run `make`. The core services will build and start automatically in the background.
* **To start the project with bonuses:** Run `make bonus`. This builds and starts the core stack plus all bonus features (Adminer, Static Website, Redis, FTP, and cAdvisor).
* **To stop the project:** Run `make down`. This safely powers off the services without losing your data.

## Accessing the Websites and Administration Panels
Once the project is running:
* **Main Website (WordPress):** Open your web browser and navigate to `https://mmravec.42.fr` (Note: You may need to accept the self-signed SSL certificate warning).
* **WordPress Admin Panel:** Navigate to `https://mmravec.42.fr/wp-admin/` to log in and manage the site.
* **Static Website (Bonus):** Navigate to `https://mmravec.42.fr/bonus/` to view the hosted resume.
* **Database Manager (Bonus):** Navigate to `http://localhost:8080` (or replace `localhost` with your VM's IP). *Important: When logging in, enter `mariadb` in the "Server" field.*
* **Monitoring Dashboard (Bonus):** Navigate to `http://localhost:8081` (or replace `localhost` with your VM's IP) to view the cAdvisor metrics.
* **FTP Server (Bonus):** Open an FTP client (like FileZilla) and connect to `localhost` (or your VM's IP) on port `21`. *Note: You must use the FTP credentials configured in your `.env` file.*

## Locating and Managing Credentials
For security reasons, passwords are not stored in the source code. All credentials (database passwords, WordPress admin login, FTP user details) are managed through a `.env` file located in the `srcs/` directory. If you are setting this up for the first time, you must create this file and define your own secure passwords before starting the project.

## Checking if Services are Running
To verify the health of the infrastructure, run the following command in your terminal:
`docker ps`
If you ran `make`, you should see three containers (`nginx`, `wordpress`, `mariadb`) listed with the status "Up". If you ran `make bonus`, you will additionally see `adminer`, `lighttpd`, `redis`, `ftp_server`, and `cadvisor`.