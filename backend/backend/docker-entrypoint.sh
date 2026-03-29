#!/bin/sh

# បង្កើតតែ Config Cache បានហើយ
php artisan config:cache

# រត់ Migration (ប្រើ --force ជានិច្ចលើ Production)
echo "Running migrations..."
php artisan migrate --force

# ចាប់ផ្ដើម Server
echo "Starting Laravel on Port 8000..."
exec php artisan serve --host=0.0.0.0 --port=8000
