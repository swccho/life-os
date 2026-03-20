<?php

namespace App\Http\Controllers\Api\Journal;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;

class JournalController extends Controller
{
    public function index(): JsonResponse
    {
        return response()->json([
            'message' => 'Journal entries list placeholder.',
            'data' => [],
        ]);
    }

    public function store(): JsonResponse
    {
        return response()->json([
            'message' => 'Journal entry store placeholder.',
            'data' => null,
        ]);
    }

    public function show(string $id): JsonResponse
    {
        return response()->json([
            'message' => 'Journal entry show placeholder.',
            'data' => ['id' => $id],
        ]);
    }

    public function update(string $id): JsonResponse
    {
        return response()->json([
            'message' => 'Journal entry update placeholder.',
            'data' => ['id' => $id],
        ]);
    }

    public function destroy(string $id): JsonResponse
    {
        return response()->json([
            'message' => 'Journal entry destroy placeholder.',
            'data' => ['id' => $id],
        ]);
    }
}
