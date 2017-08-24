FROM php:7-apache

RUN apt-get update \
    && apt-get install -y \
		wget unzip \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng12-dev \
        sqlite3 libsqlite3-dev \
        libssl-dev \
    && pecl install mongodb \
    && pecl install redis \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) iconv gd pdo pdo_sqlite \
    && a2enmod rewrite

RUN echo "extension=mongodb.so" > /usr/local/etc/php/conf.d/mongodb.ini
RUN echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini

RUN wget https://github.com/agentejo/cockpit/archive/next.zip -O /var/www/html/cockpit.zip; unzip /var/www/html/cockpit.zip -d /var/www/html/; rm /var/www/html/cockpit.zip
RUN mv /var/www/html/cockpit-next/.htaccess /var/www/html/.htaccess
RUN mv /var/www/html/cockpit-next/* /var/www/html/
RUN rm -R /var/www/html/cockpit-next/

COPY src /var/www/html/

RUN chmod 777 -R storage config

VOLUME /var/www/html/storage