<?php

use App\Http\Middleware\RoleMiddleware;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Support\Facades\Route;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        api: __DIR__ . '/../routes/api.php',
        apiPrefix: 'api',
        health: '/up',
        then: function () {
            // Root route — no web/session/CSRF middleware, pure JSON
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
        },
    )
    ->withMiddleware(function (Middleware $middleware) {
        $middleware->prepend(\Illuminate\Http\Middleware\HandleCors::class);
        $middleware->alias([
            'role' => RoleMiddleware::class,
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions) {
        //
    })
    ->create();
