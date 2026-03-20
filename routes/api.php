<?php

use App\Http\Controllers\Api\Auth\AuthController;
use App\Http\Controllers\Api\Dashboard\DashboardController;
use App\Http\Controllers\Api\Habits\HabitController;
use App\Http\Controllers\Api\Habits\HabitLogController;
use App\Http\Controllers\Api\Journal\JournalController;
use App\Http\Controllers\Api\Mood\MoodController;
use App\Http\Controllers\Api\Tasks\TaskController;
use Illuminate\Support\Facades\Route;

Route::middleware('throttle:20,1')->group(function () {
    Route::post('/register', [AuthController::class, 'register']);
    Route::post('/login', [AuthController::class, 'login']);
});

Route::middleware('auth:sanctum')->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/me', [AuthController::class, 'me']);

    Route::get('/dashboard', [DashboardController::class, 'index']);

    Route::apiResource('tasks', TaskController::class);

    Route::apiResource('habits', HabitController::class);
    Route::get('habits/{habit}/logs', [HabitLogController::class, 'index']);
    Route::post('habits/{habit}/logs', [HabitLogController::class, 'store']);
    Route::delete('habit-logs/{habit_log}', [HabitLogController::class, 'destroy']);

    Route::apiResource('journal-entries', JournalController::class);

    Route::apiResource('mood-entries', MoodController::class);
});
