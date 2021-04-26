# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: ttorbeyn <ttorbeyn@student.s19.be>         +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/04/26 12:10:02 by ttorbeyn          #+#    #+#              #
#    Updated: 2021/04/26 12:10:05 by ttorbeyn         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

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
RUN echo "daemon off;" >> /etc/nginx/nginx.conf
RUN rm -rf /var/www/html/index.nginx-debian.html
COPY ./srcs/nginx_autoindex_off.conf tmp
COPY ./srcs/nginx_autoindex_on.conf tmp

# INSTALL PHPMYADMIN
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.0.1/phpMyAdmin-5.0.1-english.tar.gz
RUN tar -xf phpMyAdmin-5.0.1-english.tar.gz && rm -rf phpMyAdmin-5.0.1-english.tar.gz
RUN mv phpMyAdmin-5.0.1-english /var/www/html/phpmyadmin
COPY ./srcs/config.inc.php /var/www/html/phpmyadmin

# INSTALL WORDPRESS
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz && rm -rf latest.tar.gz
RUN mv wordpress /var/www/html
COPY ./srcs/wp-config.php /var/www/html/wordpress

# CONFIGURE SSL
RUN openssl req -x509 -nodes -days 365 -subj "/C=BE/ST=Belgium/L=Brussels/O=42network/OU=19brussels/CN=ttor" -newkey rsa:2048 -keyout /etc/ssl/nginx-selfsigned.key -out /etc/ssl/nginx-selfsigned.crt;
RUN chown -R www-data:www-data /var/www/html/*
RUN chmod -R 755 /var/www/*

COPY ./srcs/autoindex_off.sh ./
COPY ./srcs/init.sh ./

EXPOSE 80 443

CMD bash init.sh
