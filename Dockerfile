FROM php:8.2-cli

WORKDIR /app

RUN apt-get update \
	&& apt-get install -y --no-install-recommends libzip-dev unzip \
	&& docker-php-ext-install pdo_mysql zip \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
COPY api/ ./
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN composer install --no-dev --no-interaction --prefer-dist --optimize-autoloader \
	&& chmod -R 775 storage bootstrap/cache

CMD ["sh", "-c", "php artisan migrate --force && exec php artisan serve --host=0.0.0.0 --port=${PORT:-8000}"]