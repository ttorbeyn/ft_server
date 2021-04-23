FROM debian:buster

ENV AUTOINDEX on

RUN apt-get -y update
RUN apt-get -y upgrade

# INSTALL WGET, TAR, NGINX, MARIDB, PHP
RUN apt-get -y install \
	wget \
	tar \
	nginx \
	mariadb-server \
	php7.3 \
	php-mysql \
	php-fpm \
	php-pdo \
	php-gd \
	php-cli \
	php-xml \
	php-mbstring

# CONFIGURE NGINX
COPY ./srcs/nginx_autoindex_off.config tmp
COPY ./srcs/nginx_autoindex_on.config tmp

# INSTALL PHPMYADMIN
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN tar -xf phpMyAdmin-5.0.1-english.tar.gz && rm -rf phpMyAdmin-5.0.1-english.tar.gz
RUN mv phpMyAdmin-5.0.1-english /var/www/html/phpmyadmin
COPY ./srcs/config.inc.php /var/www/html/phpmyadmin
RUN rm -rf /var/www/html/index.nginx-debian.html

# INSTALL WORDPRESS
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz && rm -rf latest.tar.gz
COPY ./srcs/wp-config.php /var/www/html/wordpress

# CONFIGURE SSL
RUN openssl req -x509 -nodes -days 365 -subj "/C=BE/ST=Belgium/L=Brussels/O=42network/OU=19brussels/CN=ttor" -newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt;
RUN chown -R www-data:www-data /var/www/html/*
RUN chmod -R 755 /var/www/*

COPY ./srcs/autoindex_off.sh tmp
COPY ./srcs/init.sh tmp
CMD bash tmp/init.sh