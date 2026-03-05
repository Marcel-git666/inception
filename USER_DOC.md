# User Documentation

This document explains how to interact with the Inception project as an end user or administrator.

## Services Provided
This infrastructure provides a fully functional, secure web stack:
1.  **Web Server (NGINX)**: Handles secure HTTPS connections from your browser.
2.  **Website (WordPress)**: A ready-to-use Content Management System where you can publish articles.
3.  **Database (MariaDB)**: A backend storage system holding your WordPress content and user accounts.

## Starting and Stopping the Project
Open a terminal in the root directory of the project:
* **To start the project:** Run `make`. The services will build and start automatically in the background.
* **To stop the project:** Run `make down`. This safely powers off the services without losing your data.

## Accessing the Website and Administration Panel
Once the project is running:
* **Main Website:** Open your web browser and navigate to `https://mmravec.42.fr` (Note: You may need to accept the self-signed SSL certificate warning).
* **Admin Panel:** Navigate to `https://mmravec.42.fr/wp-admin/` to log in and manage the site.

## Locating and Managing Credentials
For security reasons, passwords are not stored in the source code. All credentials (database passwords, WordPress admin login) are managed through a `.env` file located in the `srcs/` directory. If you are setting this up for the first time, you must create this file and define your own secure passwords before starting the project.

## Checking if Services are Running
To verify the health of the infrastructure, run the following command in your terminal:
`docker ps`
You should see three containers (`nginx`, `wordpress`, `mariadb`) listed with the status "Up".