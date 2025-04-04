FROM ubuntu:latest

# Install Apache, Node.js, and Webmin
RUN apt update && apt install -y apache2 wget perl shared-mime-info nodejs npm

# Set working directory
WORKDIR /var/www/html

# Copy package.json first for caching
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy website files
COPY . /var/www/html/

# Build the project
RUN npm run build

# Copy built assets to the root
COPY dist /var/www/html/

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html/
RUN chmod -R 755 /var/www/html/

# Enable Apache rewrite module
RUN a2enmod rewrite

# Download and install Webmin
RUN wget http://prdownloads.sourceforge.net/webadmin/webmin_2.101_all.deb && \
    dpkg --install webmin_2.101_all.deb || apt-get install -f -y

# Set the ServerName to avoid Apache warning
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# For Webmin
RUN apt update
RUN apt install net-tools iproute2 -y

# Set Webmin root password
RUN /usr/share/webmin/changepass.pl /etc/webmin root Balaji@2000

# Expose necessary ports
EXPOSE 80 10000

# Copy the startup script
COPY start.sh /start.sh

# Give execution permissions
RUN chmod +x /start.sh

# Use the script as the CMD
CMD ["/start.sh"]
