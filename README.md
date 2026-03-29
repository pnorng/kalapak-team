# 🌌 Kalapak Code Team — Mobile App

> _Together we code the universe. — Kalapak Code Team · Cambodia 🇰🇭 · Since 2024_

A cross-platform mobile application and blog/portfolio showcase for the **Kalapak Code Team** — 4 full-stack developers from Cambodia.

---

## 🛠️ Tech Stack

| Layer     | Technology            |
| --------- | --------------------- |
| Frontend  | Flutter (Dart)        |
| Backend   | Laravel 11 (PHP 8.3+) |
| Database  | PostgreSQL 16         |
| Auth      | Laravel Sanctum       |
| Container | Docker Desktop        |

---

## 🚀 Quick Start

### Prerequisites

- Docker Desktop installed and running
- Flutter SDK (for mobile development)
- Git

### 1. Clone & Setup

```bash
git clone <repo-url>
cd kalapak_mobile
cp .env.example .env
```

### 2. Start Docker Services

```bash
docker-compose up -d
```

### 3. Setup Laravel Backend

```bash
docker exec kalapak_api php artisan key:generate
docker exec kalapak_api php artisan migrate --seed
```

### 4. Run Flutter App

```bash
cd frontend
flutter pub get
flutter run
```

---

## 📱 API Base URL

- Development: `http://localhost:8000/api`

## 🔑 Default Admin Credentials

- Email: `admin@kalapak.team`
- Password: `kalapak@2024`

---

## 👥 Team

| Name           | Role                           |
| -------------- | ------------------------------ |
| Khat Vanna     | 👑 Founder & Team Leader       |
| Rom Chamraeun  | 🚀 Co-Founder · Full-Stack Dev |
| Phuem Norng    | 🚀 Co-Founder · Full-Stack Dev |
| Pheun Seanghai | 🚀 Co-Founder · Full-Stack Dev |

---

## 📬 Contact

- GitHub: [github.com/Kalapak-Team](https://github.com/Kalapak-Team)
- Email: kalapakteam@gmail.com
- Telegram: [t.me/kalapakteam](https://t.me/kalapakteam)
