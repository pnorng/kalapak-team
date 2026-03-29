# ប្រើ Alpine version ដើម្បីឱ្យ Image តូច និងដើរលឿនលើ Free Tier
FROM php:8.3-fpm-alpine

# កំណត់ទីតាំងការងារ
WORKDIR /var/www/html

# ដំឡើង System Dependencies ដែល Laravel & PostgreSQL ត្រូវការ
RUN apk add --no-cache \
    git \
    curl \
    zip \
    unzip \
    libpq-dev \
    oniguruma-dev \
    libxml2-dev \
    icu-dev \
    && docker-php-ext-install \
    pdo \
    pdo_pgsql \
    mbstring \
    xml \
    bcmath \
    opcache \
    intl

# ទាញយក Composer ចុងក្រោយបង្អស់
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# កូពីកូដទាំងអស់ចូល (លើកលែងតែអ្វីដែលមានក្នុង .dockerignore)
COPY . .

# ដំឡើង PHP Dependencies (មិនយក Dev packages ដើម្បីសម្រាលទំហំ)
RUN if [ -f "composer.json" ]; then \
    composer install --no-dev --optimize-autoloader --no-interaction --no-scripts; \
    fi

# កំណត់សិទ្ធិ (Permissions) ឱ្យត្រឹមត្រូវសម្រាប់ Laravel
# នេះជាចំណុចសំខាន់ដើម្បីការពារ Error "Permission Denied" លើ Render
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# កូពី និងផ្ដល់សិទ្ធិឱ្យ Entrypoint Script
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Render ជាទូទៅប្រើ Port 8000 ឬ 10000 (យើងប្រើ 8000 តាមអ្នក)
EXPOSE 8000

ENTRYPOINT ["docker-entrypoint.sh"]
