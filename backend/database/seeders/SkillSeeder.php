<?php

namespace Database\Seeders;

use App\Models\Skill;
use Illuminate\Database\Seeder;

class SkillSeeder extends Seeder
{
    public function run(): void
    {
        $skills = [
            // Languages
            ['name' => 'Python', 'category' => 'Languages', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/python/python-original.svg', 'sort_order' => 1],
            ['name' => 'JavaScript', 'category' => 'Languages', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/javascript/javascript-original.svg', 'sort_order' => 2],
            ['name' => 'PHP', 'category' => 'Languages', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/php/php-original.svg', 'sort_order' => 3],
            ['name' => 'Java', 'category' => 'Languages', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/java/java-original.svg', 'sort_order' => 4],
            ['name' => 'C++', 'category' => 'Languages', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/cplusplus/cplusplus-original.svg', 'sort_order' => 5],
            ['name' => 'Dart', 'category' => 'Languages', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/dart/dart-original.svg', 'sort_order' => 6],

            // Web Frontend
            ['name' => 'HTML', 'category' => 'Web Frontend', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/html5/html5-original.svg', 'sort_order' => 1],
            ['name' => 'CSS', 'category' => 'Web Frontend', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/css3/css3-original.svg', 'sort_order' => 2],
            ['name' => 'React', 'category' => 'Web Frontend', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/react/react-original.svg', 'sort_order' => 3],
            ['name' => 'TailwindCSS', 'category' => 'Web Frontend', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/tailwindcss/tailwindcss-plain.svg', 'sort_order' => 4],

            // Backend & API
            ['name' => 'Laravel', 'category' => 'Backend & API', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/laravel/laravel-plain.svg', 'sort_order' => 1],
            ['name' => 'FastAPI', 'category' => 'Backend & API', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/fastapi/fastapi-original.svg', 'sort_order' => 2],
            ['name' => 'Django', 'category' => 'Backend & API', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/django/django-plain.svg', 'sort_order' => 3],
            ['name' => 'Node.js', 'category' => 'Backend & API', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/nodejs/nodejs-original.svg', 'sort_order' => 4],
            ['name' => 'Flask', 'category' => 'Backend & API', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/flask/flask-original.svg', 'sort_order' => 5],

            // Mobile
            ['name' => 'Flutter', 'category' => 'Mobile', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/flutter/flutter-original.svg', 'sort_order' => 1],

            // Databases
            ['name' => 'MySQL', 'category' => 'Databases', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/mysql/mysql-original.svg', 'sort_order' => 1],
            ['name' => 'PostgreSQL', 'category' => 'Databases', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/postgresql/postgresql-original.svg', 'sort_order' => 2],
            ['name' => 'MongoDB', 'category' => 'Databases', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/mongodb/mongodb-original.svg', 'sort_order' => 3],
            ['name' => 'Redis', 'category' => 'Databases', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/redis/redis-original.svg', 'sort_order' => 4],

            // DevOps
            ['name' => 'Docker', 'category' => 'DevOps', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/docker/docker-original.svg', 'sort_order' => 1],
            ['name' => 'Linux', 'category' => 'DevOps', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/linux/linux-original.svg', 'sort_order' => 2],
            ['name' => 'Ubuntu', 'category' => 'DevOps', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/ubuntu/ubuntu-plain.svg', 'sort_order' => 3],
            ['name' => 'Azure', 'category' => 'DevOps', 'icon_url' => 'https://cdn.jsdelivr.net/gh/devicons/devicon/icons/azure/azure-original.svg', 'sort_order' => 4],
        ];

        foreach ($skills as $skill) {
            Skill::firstOrCreate(['name' => $skill['name'], 'category' => $skill['category']], $skill);
        }
    }
}
