FROM php:8.3-fpm

# Установка системных зависимостей
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    libzip-dev

# Очистка кеша
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Установка расширений PHP
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

RUN pecl install redis && docker-php-ext-enable redis

RUN mkdir -p /.composer && chown -R www-data:www-data /.composer

# Получение последней версии Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Установка рабочей директории
WORKDIR /var/www

# Копирование исходного кода приложения
COPY . /var/www

RUN usermod -u 1001 www-data && groupmod -g 1002 www-data

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN mkdir -p /var/www/storage /var/www/bootstrap/cache \
    && chown -R www-data:www-data /var/www \
    && chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# Установка зависимостей
RUN composer install

# Изменение прав доступа для директории storage и bootstrap/cache
RUN chmod -R 777 storage bootstrap/cache

# Запуск PHP-FPM
CMD ["php-fpm"]

EXPOSE 9000
