<?php

namespace App\Http\Controllers;

use Illuminate\Http\JsonResponse;

class TeamController extends Controller
{
    public function index(): JsonResponse
    {
        $team = [
            [
                'id' => 1,
                'name' => 'Khat Vanna',
                'role' => 'Founder & Team Leader',
                'title' => 'Full-Stack Developer',
                'badge' => '👑',
                'skills' => ['Laravel', 'Flutter', 'React', 'PostgreSQL', 'Docker'],
                'github' => 'https://github.com/khatvanna',
            ],
            [
                'id' => 2,
                'name' => 'Rom Chamraeun',
                'role' => 'Co-Founder',
                'title' => 'Full-Stack Developer',
                'badge' => '🚀',
                'skills' => ['Python', 'FastAPI', 'React', 'MongoDB', 'Linux'],
                'github' => 'https://github.com/romchamraeun',
            ],
            [
                'id' => 3,
                'name' => 'Phuem Norng',
                'role' => 'Co-Founder',
                'title' => 'Full-Stack Developer',
                'badge' => '🚀',
                'skills' => ['Node.js', 'Vue.js', 'MySQL', 'Docker', 'Azure'],
                'github' => 'https://github.com/phuemnorng',
            ],
            [
                'id' => 4,
                'name' => 'Pheun Seanghai',
                'role' => 'Co-Founder',
                'title' => 'Full-Stack Developer',
                'badge' => '🚀',
                'skills' => ['Java', 'Spring Boot', 'Flutter', 'PostgreSQL', 'Redis'],
                'github' => 'https://github.com/pheunseanghai',
            ],
        ];

        return response()->json(['data' => $team]);
    }
}
