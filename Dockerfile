FROM php:7-apache
MAINTAINER martin scharm <https://binfalse.de/contact/>

# for mail configuration see https://binfalse.de/2016/11/25/mail-support-for-docker-s-php-fpm/

# install dependencies and enable common apache modules
RUN apt-get update \
 && apt-get install -y -q --no-install-recommends \
    wget \
    curl \
    unzip \
    zlib1g-dev \
    libpng-dev \
    libjpeg62-turbo \
    libjpeg62-turbo-dev \
    libcurl4-openssl-dev \
    libfreetype6-dev \
    libmcrypt-dev \
    libxml2-dev \
    libzip-dev \
    msmtp \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/* \
 && a2enmod expires headers rewrite

# install php extensions
RUN docker-php-source extract \
 && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 && docker-php-ext-install -j$(nproc) zip gd curl pdo pdo_mysql soap intl \
 && docker-php-source delete

# copy composer install script into the container
ADD install-composer.sh /install-composer.sh

# install composer
RUN bash /install-composer.sh \
 && chown -R www-data: /var/www

# chaneg the user and install contao 4
USER www-data
RUN php -d memory_limit=-1 /composer/composer.phar create-project contao/managed-edition /var/www/html '4.4.*'

