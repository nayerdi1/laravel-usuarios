# ---------- Imagen base ----------
FROM php:8.2-fpm

# Instalar extensiones necesarias
RUN apt-get update && apt-get install -y \
    nginx \
    libzip-dev zip unzip \
    libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring xml zip

# Copiar Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Crear carpeta del proyecto
WORKDIR /var/www/html

# Copiar el proyecto Laravel
COPY . .

# Crear .env desde .env.example
RUN cp .env.example .env

# Instalar dependencias PHP
RUN composer install --no-dev --optimize-autoloader

# Generar APP_KEY
RUN php artisan key:generate

# Permisos
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# ---------- Configuración Nginx ----------
RUN rm /etc/nginx/sites-enabled/default

# Crear configuración correcta para Laravel
RUN printf "server {\n\
    listen 8080;\n\
    root /var/www/html/public;\n\
    index index.php index.html;\n\
\n\
    location / {\n\
        try_files \$uri \$uri/ /index.php?\$query_string;\n\
    }\n\
\n\
    location ~ \.php$ {\n\
        include fastcgi_params;\n\
        fastcgi_pass 127.0.0.1:9000;\n\
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;\n\
    }\n\
}" > /etc/nginx/sites-enabled/laravel.conf

# Exponer puerto para Render
EXPOSE 8080

# ---------- Start ----------
CMD service nginx start && php-fpm