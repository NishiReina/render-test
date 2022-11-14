#!/usr/bin/env bash
echo "Running composer"
composer global require hirak/prestissimo
composer install --no-dev --working-dir=/var/www/html

echo "vite"
npm install
npm run build

echo "Caching config..."
php artisan config:cache

echo "Caching routes..."
php artisan route:cache

echo "Caching cache..."
php artisan cache:clear

echo "Caching view..."
php artisan view:clear

echo "symbolic link"
php artisan storage:link

echo "Running migrations..."
php artisan migrate --force

