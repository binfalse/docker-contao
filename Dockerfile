FROM php:7.0-apache
MAINTAINER martin scharm <https://binfalse.de/contact/>

# for mail configuration see https://binfalse.de/2016/11/25/mail-support-for-docker-s-php-fpm/

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
    ssmtp \
 && apt-get clean \
 && rm -r /var/lib/apt/lists/* \
 && a2enmod expires headers

RUN wget https://download.contao.org/3.5/zip -O /tmp/contao.zip \
 && unzip /tmp/contao.zip -d /var/www/ \
 && rm -rf /var/www/html /tmp/contao.zip \
 && ln -s /var/www/contao* /var/www/html \
 && echo 0 > /var/www/html/system/cron/cron.txt \
 && chown -R www-data: /var/www/contao* \
 && a2enmod rewrite

RUN docker-php-source extract \
 && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 && docker-php-ext-install -j$(nproc) zip gd curl mysqli soap \
 && docker-php-source delete

ADD install-composer.sh /install-composer.sh

RUN bash /install-composer.sh

