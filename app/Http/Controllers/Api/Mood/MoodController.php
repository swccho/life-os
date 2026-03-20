<?php

namespace App\Http\Controllers\Api\Mood;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;

class MoodController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json([
            'message' => 'Mood logs list placeholder.',
            'data' => [],
        ]);
    }

    public function store(): JsonResponse
    {
        return response()->json([
            'message' => 'Mood log store placeholder.',
            'data' => null,
        ]);
    }

    public function show(string $id): JsonResponse
    {
        return response()->json([
            'message' => 'Mood log show placeholder.',
            'data' => ['id' => $id],
        ]);
    }

    public function update(string $id): JsonResponse
    {
        return response()->json([
            'message' => 'Mood log update placeholder.',
            'data' => ['id' => $id],
        ]);
    }

    public function destroy(string $id): JsonResponse
    {
        return response()->json([
            'message' => 'Mood log destroy placeholder.',
            'data' => ['id' => $id],
        ]);
    }
}
