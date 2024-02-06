FROM php:8.2-apache

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
RUN rm /etc/apache2/sites-enabled/000-default.conf
COPY ./docker/build/vhosts/vhosts.conf /etc/apache2/sites-enabled/vhosts.conf
RUN echo 'deb [trusted=yes] https://repo.symfony.com/apt/ /' | tee /etc/apt/sources.list.d/symfony-cli.list
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
     locales \
     apt-utils \
     git \
     libicu-dev \
     g++ \
     libpng-dev \
     libxml2-dev \
     libzip-dev \
     libonig-dev \
     libxslt-dev \
     libssh-dev

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    echo "fr_FR.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen

# Composer
RUN echo "Installation de composer"
RUN curl -sSk https://getcomposer.org/installer | php -- --disable-tls && \
   mv composer.phar /usr/local/bin/composer

#Ouverture des droits de lecture, modification et execution
RUN echo "Ouverture des droits de lecture, modification et execution"
RUN chmod 777 -R /var/www

# Configuration du WORKDIR
RUN echo "Configuration du WORKDIR"
WORKDIR /var/www/


RUN rm -r /var/www/html
COPY ./ /var/www

RUN chown -R www-data:www-data /var/www