<?php

namespace App\Http\Controllers\Api\Auth;

use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;

class AuthController extends Controller
{
    public function login(): JsonResponse
    {
        return response()->json([
            'message' => 'Auth login placeholder.',
            'data' => null,
        ]);
    }

    public function register(): JsonResponse
    {
        return response()->json([
            'message' => 'Auth register placeholder.',
            'data' => null,
        ]);
    }

    public function logout(): JsonResponse
    {
        return response()->json([
            'message' => 'Auth logout placeholder.',
            'data' => null,
        ]);
    }
}
