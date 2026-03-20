<?php

namespace App\Http\Controllers\Api\Dashboard;

use App\Http\Controllers\Controller;
use App\Http\Resources\DashboardResource;
use App\Services\DashboardService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function __construct(
        private readonly DashboardService $dashboardService
    ) {}

    public function index(Request $request): JsonResponse
    {
        $summary = $this->dashboardService->buildSummary($request->user());

        return $this->successResponse(
            (new DashboardResource($summary))->resolve(),
            'Dashboard summary fetched successfully.'
        );
    }
}
