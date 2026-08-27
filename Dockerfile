FROM php:8.2-cli

WORKDIR /app

RUN docker-php-ext-install pdo_mysql

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY api/composer.json api/composer.lock ./
RUN composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader

COPY api/ ./
RUN chmod -R 775 storage bootstrap/cache

CMD ["sh", "-c", "php artisan migrate --force && exec php artisan serve --host=0.0.0.0 --port=${PORT:-8000}"]