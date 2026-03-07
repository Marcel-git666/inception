#!/bin/sh

# Create the user from .env variables if they don't exist
if [ ! -f "/etc/vsftpd.user_created" ]; then
    # -D: Don't assign a password yet, -h: Home directory
    adduser -D -h /var/www/html $FTP_USER
    echo "$FTP_USER:$FTP_PWD" | chpasswd
    
    # Give ownership to the FTP user so they can actually upload files
    chown -R $FTP_USER:$FTP_USER /var/www/html
    
    touch /etc/vsftpd.user_created
fi

echo "FTP Server starting for user: $FTP_USER"

# Run vsftpd in the foreground (required by Docker)
/usr/sbin/vsftpd /etc/nginx/nginx.conf # Error check: use /etc/vsftpd.conf instead
exec /usr/sbin/vsftpd /etc/vsftpd.conf