#!/bin/bash

# Update system
apt update

# Install Apache
apt install apache2 -y

# MySQL set root password
echo "mysql-server mysql-server/root_password password rootpassword" | debconf-set-selections
echo "mysql-server mysql-server/root_password_again password rootpassword" | debconf-set-selections

# Install MySQL
apt install mysql-server -y

# MySQL server requires restart for docker container
service mysql restart

# Create wordpress db
mysql -u root -prootpassword -e "CREATE DATABASE wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
mysql -u root -prootpassword -e "GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password';"
mysql -u root -prootpassword -e "FLUSH PRIVILEGES;"

# Install PHP
apt install -y php \
    libapache2-mod-php \
    php-mcrypt \
    php-mysql \
    php-curl \
    php-gd \
    php-mbstring \
    php-xml \
    php-xmlrpc

# Index php files first
echo "
<IfModule mod_dir.c>
    DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IFModule>
" > /etc/apache2/mods-enabled/dir.conf

# PHPmyadmin config questions
echo 'phpmyadmin phpmyadmin/dbconfig-install boolean true' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/app-password-confirm password phpmyadminpass' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/admin-pass password rootpassword' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/mysql/app-pass password rootpassword' | debconf-set-selections
echo 'phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2' | debconf-set-selections

# PHPmyadmin Install
apt install -y phpmyadmin php-gettext

# Enable PHP Mods
phpenmod mcrypt
phpenmod mbstring

# Allow .htaccess files
echo "
<Directory /var/www/html>
    AllowOverride ALL
</Directory>
" >> /etc/apache2/apache2.conf

# Enable mod_rewrite
a2enmod rewrite

# Restart apache
service apache2 restart

# Download WordPress and unzip
cd /tmp
curl -O https://wordpress.org/latest.tar.gz # -O/--remote-name
tar xzvf latest.tar.gz # xzvf -x/--extract -z/--gzip -v/--verbose -f/--file

# .htaccess setup
touch /tmp/wordpress/.htaccess
chmod 660 /tmp/wordpress/.htaccess

# Config file setup, upgrade setup
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
mkdir /tmp/wordpress/wp-content/upgrade

# Copy to apache www
cp -a /tmp/wordpress/. /var/www/html # -a/--archive

# Ownership/permission settings
chown -R www-data:www-data /var/www/html # -R/--recursive
find /var/www/html -type d -exec chmod g+s {} \;
chmod g+w /var/www/html/wp-content
chmod -R g+w /var/www/html/wp-content/themes
chmod -R g+w /var/www/html/wp-content/plugins

# WordPress db config
sed -i "/DB_NAME/c\define('DB_NAME', 'wordpress');" /var/www/html/wp-config.php
sed -i "/DB_USER/c\define('DB_USER', 'wordpressuser');" /var/www/html/wp-config.php
sed -i "/DB_PASSWORD/c\define('DB_PASSWORD', 'password');" /var/www/html/wp-config.php
