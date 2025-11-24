# Imagen oficial de PHP 8.2 con Apache
FROM php:8.2-apache

# Instalar extensiones necesarias
RUN docker-php-ext-install pdo pdo_mysql

# Copiar el proyecto
COPY . /var/www/html

# Copiar .env.example a .env
RUN cp /var/www/html/.env.example /var/www/html/.env

# Habilitar mod_rewrite
RUN a2enmod rewrite

# Establecer documento raíz correcto
WORKDIR /var/www/html

# Asignar permisos
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Exponer puerto
EXPOSE 80

# Iniciar Apache
CMD ["apache2-foreground"]