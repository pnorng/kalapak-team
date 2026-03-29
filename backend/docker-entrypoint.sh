#!/bin/sh

# ── 1. Bootstrap .env ────────────────────────────────────────────────────
# Laravel needs a .env file (artisan commands and HTTP requests require it)
if [ ! -f /var/www/html/.env ]; then
    cp /var/www/html/.env.example /var/www/html/.env
fi

# Write Render-injected environment variables into .env
[ -n "$APP_NAME" ]     && sed -i "s|^APP_NAME=.*|APP_NAME=$APP_NAME|" .env
[ -n "$APP_ENV" ]      && sed -i "s|^APP_ENV=.*|APP_ENV=$APP_ENV|" .env
[ -n "$APP_KEY" ]      && sed -i "s|^APP_KEY=.*|APP_KEY=$APP_KEY|" .env
[ -n "$APP_URL" ]      && sed -i "s|^APP_URL=.*|APP_URL=$APP_URL|" .env
[ -n "$APP_DEBUG" ]    && sed -i "s|^APP_DEBUG=.*|APP_DEBUG=$APP_DEBUG|" .env
[ -n "$DATABASE_URL" ] && { grep -q "^DATABASE_URL=" .env && sed -i "s|^DATABASE_URL=.*|DATABASE_URL=$DATABASE_URL|" .env || echo "DATABASE_URL=$DATABASE_URL" >> .env; }
[ -n "$DB_HOST" ]      && sed -i "s|^DB_HOST=.*|DB_HOST=$DB_HOST|" .env
[ -n "$DB_PORT" ]      && sed -i "s|^DB_PORT=.*|DB_PORT=$DB_PORT|" .env
[ -n "$DB_DATABASE" ]  && sed -i "s|^DB_DATABASE=.*|DB_DATABASE=$DB_DATABASE|" .env
[ -n "$DB_USERNAME" ]  && sed -i "s|^DB_USERNAME=.*|DB_USERNAME=$DB_USERNAME|" .env
[ -n "$DB_PASSWORD" ]  && sed -i "s|^DB_PASSWORD=.*|DB_PASSWORD=$DB_PASSWORD|" .env

# Auto-generate APP_KEY if still a placeholder or empty
if grep -qE "^APP_KEY=(base64:YOUR_APP_KEY_HERE)?$" .env; then
    echo "APP_KEY not set — generating one now..."
    php artisan key:generate --force
fi

# ── 2. Clear stale caches then rebuild ──────────────────────────────────
# Note: route:cache is intentionally omitted — closure-based routes cannot be cached
php artisan optimize:clear
php artisan config:cache

# ── 3. Migrate & seed ────────────────────────────────────────────────────
echo "Running migrations..."
php artisan migrate:fresh --seed --force

# ── 4. Start server ──────────────────────────────────────────────────────
echo "Starting Laravel on Port 8000..."
exec php artisan serve --host=0.0.0.0 --port=8000
