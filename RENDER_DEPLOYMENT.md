# 🚀 Render Deployment Guide - Kalapak Mobile

## Quick Setup for Render + Neon PostgreSQL

---

## 1️⃣ CONFIGURATION FORM

### Basic Settings

```
Name:                    kalapak-api
Language:                Docker
Branch:                  main
Region:                  Virginia (US East)
Root Directory:          backend
Dockerfile Path:         backend/Dockerfile
Instance Type:           Starter ($7/month)
```

---

## 2️⃣ ENVIRONMENT VARIABLES

Use **"Add from .env"** button and update these values:

### Production Database (Neon)

```
DB_CONNECTION=pgsql
DATABASE_URL=postgresql://[USER]:[PASSWORD]@[HOST]/[DATABASE]?sslmode=require
```

### App Configuration

```
APP_NAME=KalapakAPI
APP_ENV=production
APP_DEBUG=false
APP_KEY=base64:[YOUR_GENERATED_KEY]
APP_URL=https://kalapak-team.onrender.com
```

### Logging

```
LOG_CHANNEL=stderr
LOG_LEVEL=error
```

### Services

```
BROADCAST_DRIVER=log
CACHE_DRIVER=file
FILESYSTEM_DISK=local
QUEUE_CONNECTION=sync
SESSION_DRIVER=array
SESSION_LIFETIME=120
```

### Security

```
SANCTUM_STATEFUL_DOMAINS=kalapak-api.onrender.com,localhost
```

### Email (Optional)

```
MAIL_MAILER=smtp
MAIL_HOST=smtp.gmail.com
MAIL_PORT=587
MAIL_USERNAME=[YOUR_EMAIL]
MAIL_PASSWORD=[YOUR_APP_PASSWORD]
MAIL_ENCRYPTION=tls
MAIL_FROM_ADDRESS=noreply@kalapak.team
MAIL_FROM_NAME=KalapakAPI
```

---

## 3️⃣ GETTING YOUR VALUES

### From Neon Console (https://console.neon.tech)

1. Go to your project
2. Click "Connection string" or "Postgres URL"
3. Copy the full URL: `postgresql://user:password@host/database?sslmode=require`

This is your **DATABASE_URL** value. Use it directly without breaking it apart.

### Generate APP_KEY

```bash
cd backend
php artisan key:generate --show
```

Copy output: `base64:xxxxxxxxxxxxx=`

---

## 4️⃣ DEPLOYMENT STEPS

1. **Update Root Directory**: `backend`
2. **Update Dockerfile Path**: `backend/Dockerfile`
3. **Click "Add from .env"**
4. **Edit Neon values** (DB_HOST, DB_USERNAME, DB_PASSWORD, DATABASE_URL)
5. **Edit Email values** (optional - for sending emails)
6. **Click "Deploy Web Service"**
7. **Wait 5-10 minutes** for build to complete

---

## 5️⃣ VERIFY DEPLOYMENT

After deployment completes:

```bash
# Test your API
curl https://kalapak-api.onrender.com/api/team

# Should return JSON response
```

Your API URL: **https://kalapak-api.onrender.com**

---

## 6️⃣ TROUBLESHOOTING

### Check Logs

- Go to Render Dashboard → Your Service → "Logs" tab

### Common Issues

- **Database connection failed**: Check DB_HOST, DB_PASSWORD in .env
- **Build failed**: Check Dockerfile path is `backend/Dockerfile`
- **Port error**: Make sure port 8000 is exposed in Dockerfile

### Reset Database

Log into Render SSH and run:

```bash
php artisan migrate:fresh --seed
```

---

## 📋 CHECKLIST

- [ ] Neon database created
- [ ] Connection string copied
- [ ] APP_KEY generated
- [ ] backend/.env updated with production values
- [ ] Code pushed to GitHub (main branch)
- [ ] Render form filled correctly
- [ ] All environment variables added via .env
- [ ] Deploy button clicked
- [ ] Deployment completed successfully
- [ ] API URL tested with curl
