<?php

namespace App\Http\Controllers\Api\Tasks;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;

class TaskController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json([
            'message' => 'Tasks list placeholder.',
            'data' => [],
        ]);
    }

    public function store(): JsonResponse
    {
        return response()->json([
            'message' => 'Task store placeholder.',
            'data' => null,
        ]);
    }

    public function show(string $id): JsonResponse
    {
        return response()->json([
            'message' => 'Task show placeholder.',
            'data' => ['id' => $id],
        ]);
    }

    public function update(string $id): JsonResponse
    {
        return response()->json([
            'message' => 'Task update placeholder.',
            'data' => ['id' => $id],
        ]);
    }

    public function destroy(string $id): JsonResponse
    {
        return response()->json([
            'message' => 'Task destroy placeholder.',
            'data' => ['id' => $id],
        ]);
    }
}
