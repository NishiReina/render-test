# richarvey/nginx-php-fpmをベースとする
FROM richarvey/nginx-php-fpm:2.1.2

COPY . .

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

RUN apt install -y npm \
  && npm install n -g \
  && n 16

# RUN curl -sL https://deb.nodesource.com/setup_18.x | bash -
# RUN apt-get install -y nodejs

CMD ["/start.sh"]