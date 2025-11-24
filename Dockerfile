FROM php:8.2-fpm

# Instala dependencias para Laravel
RUN apt-get update && apt-get install -y \
  libzip-dev zip unzip \
  libpng-dev libonig-dev libxml2-dev \
&& docker-php-ext-install pdo_mysql mbstring xml zip

# Copia Composer desde la imagen oficial de Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

# Copia el proyecto
COPY . .

# Instala dependencias de PHP
RUN composer install --no-dev --optimize-autoloader

# Genera la clave de la app
RUN php artisan key:generate

# Da los permisos correctos (si es necesario)
RUN chown -R www-data:www-data /var/www/html

# Expone el puerto (ejemplo)
EXPOSE 9000