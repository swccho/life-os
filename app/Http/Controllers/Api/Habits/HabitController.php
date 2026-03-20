<?php

namespace App\Http\Controllers\Api\Habits;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;

class HabitController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json([
            'message' => 'Habits list placeholder.',
            'data' => [],
        ]);
    }

    public function store(): JsonResponse
    {
        return response()->json([
            'message' => 'Habit store placeholder.',
            'data' => null,
        ]);
    }

    public function show(string $id): JsonResponse
    {
        return response()->json([
            'message' => 'Habit show placeholder.',
            'data' => ['id' => $id],
        ]);
    }

    public function update(string $id): JsonResponse
    {
        return response()->json([
            'message' => 'Habit update placeholder.',
            'data' => ['id' => $id],
        ]);
    }

    public function destroy(string $id): JsonResponse
    {
        return response()->json([
            'message' => 'Habit destroy placeholder.',
            'data' => ['id' => $id],
        ]);
    }
}
