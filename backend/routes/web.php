<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return response()->json([
        'status' => 'success',
        'app' => 'Kalapak API',
        'version' => '1.0.0',
        'message' => 'Welcome to Kalapak API. Use /api/* endpoints.',
        'endpoints' => [
            'health' => '/api/health-check',
            'team' => '/api/team',
            'skills' => '/api/skills',
            'projects' => '/api/projects',
            'posts' => '/api/posts',
        ],
    ]);
});
