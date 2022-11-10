FROM node:16-slim as node-builder

COPY . ./app
RUN cd /app && npm ci && npm run prod


FROM php:8.1.5-apache

RUN apt-get update && apt-get install -y \
  zip \
  unzip \
  git

RUN docker-php-ext-install -j "$(nproc)" opcache && docker-php-ext-enable opcache

RUN sed -i 's/80/8080/g' /etc/apache2/sites-available/000-default.conf /etc/apache2/ports.conf
RUN sed -i 's#/var/www/html#/var/www/html/public#g' /etc/apache2/sites-available/000-default.conf
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

COPY --from=composer:2.0 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html
COPY . ./
COPY --from=node-builder /app/public ./public
RUN composer install
RUN chown -Rf www-data:www-data ./



# # richarvey/nginx-php-fpmをベースとする
# FROM richarvey/nginx-php-fpm:2.1.2

# COPY . .

# Image config
ENV SKIP_COMPOSER 1
ENV WEBROOT /var/www/html/public
ENV PHP_ERRORS_STDERR 1
ENV RUN_SCRIPTS 1
ENV REAL_IP_HEADER 1

# Laravel config
ENV APP_ENV production
ENV APP_DEBUG false
ENV LOG_CHANNEL stderr

# Allow composer to run as root
ENV COMPOSER_ALLOW_SUPERUSER 1


# npm command install

# RUN apt update
# RUN apt install -y wget git unzip libpq-dev

# RUN apt install -y npm \
#   && npm install n -g \
#   && n 16

# RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
# RUN apt-get install -y nodejs

CMD ["/start.sh"]