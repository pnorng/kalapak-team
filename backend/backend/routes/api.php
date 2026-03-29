<?php

use App\Http\Controllers\Auth\AuthController;
use App\Http\Controllers\ContactController;
use App\Http\Controllers\PostController;
use App\Http\Controllers\ProjectController;
use App\Http\Controllers\SkillController;
use App\Http\Controllers\TeamController;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes — Kalapak Code Team
|--------------------------------------------------------------------------
*/

// ── Auth ─────────────────────────────────────────────────────────────────
Route::prefix('auth')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);

    Route::middleware('auth:sanctum')->group(function () {
        Route::post('/logout', [AuthController::class, 'logout']);
        Route::get('/me', [AuthController::class, 'me']);
        Route::put('/profile', [AuthController::class, 'updateProfile']);
    });
});

// ── Public Routes ─────────────────────────────────────────────────────────
Route::get('/team', [TeamController::class, 'index']);
Route::get('/contact', [ContactController::class, 'index'])->middleware(['auth:sanctum', 'role:admin']);
Route::post('/contact', [ContactController::class, 'store']);
Route::patch('/contact/{contactMessage}/read', [ContactController::class, 'markRead'])
    ->middleware(['auth:sanctum', 'role:admin']);

// Skills
Route::get('/skills', [SkillController::class, 'index']);
Route::middleware(['auth:sanctum', 'role:admin'])->group(function () {
    Route::post('/skills', [SkillController::class, 'store']);
    Route::put('/skills/{skill}', [SkillController::class, 'update']);
    Route::delete('/skills/{skill}', [SkillController::class, 'destroy']);
});

// Projects
Route::get('/projects', [ProjectController::class, 'index']);
Route::get('/projects/{project}', [ProjectController::class, 'show']);
Route::middleware(['auth:sanctum', 'role:admin'])->group(function () {
    Route::post('/projects', [ProjectController::class, 'store']);
    Route::put('/projects/{project}', [ProjectController::class, 'update']);
    Route::delete('/projects/{project}', [ProjectController::class, 'destroy']);
});

// Posts / Blog
Route::get('/posts', [PostController::class, 'index']);
Route::get('/posts/{slug}', [PostController::class, 'show']);
Route::get('/posts/{post}/comments', [PostController::class, 'comments']);

Route::middleware(['auth:sanctum', 'role:user,admin'])->group(function () {
    Route::post('/posts/{post}/like', [PostController::class, 'like']);
    Route::post('/posts/{post}/comment', [PostController::class, 'comment']);
});

Route::middleware(['auth:sanctum', 'role:admin'])->group(function () {
    Route::post('/posts', [PostController::class, 'store']);
    Route::put('/posts/{post}', [PostController::class, 'update']);
    Route::delete('/posts/{post}', [PostController::class, 'destroy']);
});
