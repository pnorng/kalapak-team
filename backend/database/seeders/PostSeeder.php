<?php

namespace Database\Seeders;

use App\Models\Post;
use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Str;

class PostSeeder extends Seeder
{
    public function run(): void
    {
        $admin = User::where('role', 'admin')->first();

        $posts = [
            [
                'title' => 'Welcome to Kalapak Code Team',
                'category' => 'Announcement',
                'thumbnail' => 'https://images.unsplash.com/photo-1461749280684-dccba630e2f6?w=800',
                'content' => "# Welcome to Kalapak Code Team! 🌌\n\nWe are a passionate group of 4 full-stack developers from Cambodia 🇰🇭, founded in 2024.\n\n## Our Mission\n\nTo build modern, scalable, and impactful software solutions while sharing our knowledge with the community.\n\n## What We Do\n\n- **Full-Stack Web Development** — Laravel, React, Node.js\n- **Mobile Development** — Flutter for cross-platform apps\n- **AI & Cloud** — Integrating cutting-edge AI tools\n- **Open Source** — Contributing back to the community\n\n> *A life lived for others is the only life worth living.*\n\nStay tuned for more updates from the Kalapak team!",
            ],
            [
                'title' => 'Building a Dark Cosmic Flutter App',
                'category' => 'Tutorial',
                'thumbnail' => 'https://images.unsplash.com/photo-1614728894747-a83421e2b9c9?w=800',
                'content' => "# Building a Dark Cosmic Flutter App\n\nIn this tutorial, we'll walk through creating a stunning dark-themed Flutter application with galaxy aesthetics.\n\n## Prerequisites\n\n- Flutter SDK 3.x\n- VS Code with Flutter extension\n- Basic Dart knowledge\n\n## Color Palette\n\n```dart\nconst Color kDeepSpace    = Color(0xFF020024);\nconst Color kNebulaPurple = Color(0xFF7B2FFF);\nconst Color kCyberBlue    = Color(0xFF00D4FF);\n```\n\n## Glassmorphism Cards\n\nUsing BackdropFilter for frosted glass effects creates a beautiful cosmic feel that pairs perfectly with our deep space background.\n\n## Conclusion\n\nDark themes with neon accents create an immersive experience perfect for tech-focused applications.",
            ],
            [
                'title' => 'Docker + Laravel 11 + PostgreSQL Setup Guide',
                'category' => 'DevOps',
                'thumbnail' => 'https://images.unsplash.com/photo-1605745341112-85968b19335b?w=800',
                'content' => "# Docker + Laravel 11 + PostgreSQL Setup\n\nA complete guide to containerizing your Laravel application with PostgreSQL.\n\n## docker-compose.yml\n\n```yaml\nservices:\n  postgres:\n    image: postgres:16-alpine\n    environment:\n      POSTGRES_DB: myapp_db\n      POSTGRES_PASSWORD: secret\n```\n\n## Key Steps\n\n1. Install Docker Desktop\n2. Create docker-compose.yml\n3. Configure .env for PostgreSQL\n4. Run `docker-compose up -d`\n5. Execute migrations\n\n## Benefits\n\n- Consistent development environments\n- Easy onboarding for new team members\n- Production-ready configuration\n\nHappy containerizing!",
            ],
        ];

        foreach ($posts as $postData) {
            Post::firstOrCreate(
                ['slug' => Str::slug($postData['title']) . '-kalapak'],
                [
                    ...$postData,
                    'slug' => Str::slug($postData['title']) . '-kalapak',
                    'author_id' => $admin?->id,
                    'is_published' => true,
                ]
            );
        }
    }
}
