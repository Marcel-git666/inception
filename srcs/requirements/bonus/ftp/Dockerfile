# Using Alpine 3.22 as the penultimate stable version
FROM alpine:3.22

# Install vsftpd (Very Secure FTP Daemon)
RUN apk update && apk add --no-cache vsftpd

# Create the secure_chroot_dir that vsftpd expects
RUN mkdir -p /var/run/vsftpd/empty && chmod 555 /var/run/vsftpd/empty

# Copy the configuration and the entrypoint script
COPY conf/vsftpd.conf /etc/vsftpd.conf
COPY tools/ftp_setup.sh /ftp_setup.sh

# Port 21 for command channel, 30000-30009 for passive data transfer
EXPOSE 21 30000-30009

# Using a script to handle user creation from environment variables
ENTRYPOINT ["sh", "/ftp_setup.sh"]