FROM ubuntu:20.04

# Install Apache2
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y apache2

# Create a new user with access permissions to Apache2
RUN useradd -m -s /bin/bash myuser && \
    chown -R myuser:myuser /var/www/html && \
    chmod -R 755 /var/www/html && \
    echo "myuser:password" | chpasswd

# Create a volume at /var/www/html
VOLUME /var/www/html

# Set the user and group ID for Apache2 to match the myuser user and group ID
RUN sed -i 's/www-data/myuser/g' /etc/apache2/envvars && \
    sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=myuser/g' /etc/apache2/envvars && \
    sed -i 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=myuser/g' /etc/apache2/envvars

# Start Apache2
CMD [ "apache2ctl", "-D", "FOREGROUND" ]

# EXPOSE port 3000
EXPOSE 3000

