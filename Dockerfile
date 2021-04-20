FROM debian:buster

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
	php-mbstring

# CONFIGURE NGINX
COPY ./srcs/nginx.config etc/nginx/sites-available/default

# INSTALL PHPMYADMIN
WORKDIR /var/www/html/
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN tar -xf phpMyAdmin-5.0.1-english.tar.gz && rm -rf phpMyAdmin-5.0.1-english.tar.gz
RUN mv phpMyAdmin-5.0.1-english phpmyadmin
COPY ./srcs/config.inc.php phpmyadmin

# INSTALL WORDPRESS
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz && rm -rf latest.tar.gz
COPY ./srcs/wp-config.php ./

# CONFIGURE SSL
RUN openssl req -x509 -nodes -days 365 -subj "/C=BE/ST=Belgium/L=Brussels/O=42network/OU=19brussels/CN=ttor" -newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt;
RUN chown -R www-data:www-data *
RUN chmod -R 755 /var/www/*

COPY ./srcs/init.sh ./
CMD bash init.sh