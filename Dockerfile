FROM php:apache
MAINTAINER martin scharm

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
 && apt-get clean \
 && rm -r /var/lib/apt/lists/*

RUN wget https://download.contao.org/3.5/zip -O /tmp/contao.zip \
 && unzip /tmp/contao.zip -d /var/www/ \
 && rm -rf /var/www/html /tmp/contao.zip \
 && ln -s /var/www/contao* /var/www/html \
 && chown -R www-data: /var/www/contao* \
 && a2enmod rewrite

RUN docker-php-source extract \
 && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
 && docker-php-ext-install -j$(nproc) zip gd curl mysqli \
 && docker-php-source delete

RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
 && php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" \
 && mkdir -p composer/packages \
 && php composer-setup.php --install-dir=composer \
 && php -r "unlink('composer-setup.php');"

