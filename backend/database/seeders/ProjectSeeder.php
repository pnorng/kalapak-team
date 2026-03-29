<?php

namespace Database\Seeders;

use App\Models\Project;
use Illuminate\Database\Seeder;

class ProjectSeeder extends Seeder
{
    public function run(): void
    {
        $projects = [
            [
                'title' => 'Kalapak Mobile App',
                'description' => 'Cross-platform mobile app for the Kalapak Code Team blog and portfolio showcase. Built with Flutter and Laravel.',
                'cover_image' => 'https://images.unsplash.com/photo-1512941937669-90a1b58e7e9c?w=800',
                'tech_stack' => ['Flutter', 'Laravel', 'PostgreSQL', 'Docker'],
                'github_url' => 'https://github.com/Kalapak-Team/kalapak-mobile',
                'is_featured' => true,
            ],
            [
                'title' => 'AI Chat Assistant',
                'description' => 'An intelligent chat assistant powered by FastAPI and integrated with modern LLM APIs for smart conversations.',
                'cover_image' => 'https://images.unsplash.com/photo-1677442135703-1787eea5ce01?w=800',
                'tech_stack' => ['Python', 'FastAPI', 'React', 'PostgreSQL'],
                'github_url' => 'https://github.com/Kalapak-Team/ai-chat',
                'is_featured' => true,
            ],
            [
                'title' => 'E-Commerce Platform',
                'description' => 'Full-featured e-commerce solution with inventory management, payment gateway, and real-time order tracking.',
                'cover_image' => 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d?w=800',
                'tech_stack' => ['Laravel', 'Vue.js', 'MySQL', 'Redis'],
                'github_url' => 'https://github.com/Kalapak-Team/ecommerce',
                'is_featured' => false,
            ],
            [
                'title' => 'DevOps Dashboard',
                'description' => 'Real-time monitoring dashboard for Docker containers and cloud infrastructure with alert notifications.',
                'cover_image' => 'https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800',
                'tech_stack' => ['Node.js', 'React', 'Docker', 'Azure'],
                'github_url' => 'https://github.com/Kalapak-Team/devops-dashboard',
                'is_featured' => false,
            ],
        ];

        foreach ($projects as $project) {
            Project::firstOrCreate(['title' => $project['title']], $project);
        }
    }
}
