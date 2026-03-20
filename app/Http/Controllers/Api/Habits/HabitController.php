<?php

namespace App\Http\Controllers\Api\Habits;

use App\Http\Controllers\Controller;
use App\Http\Requests\Habits\StoreHabitRequest;
use App\Http\Requests\Habits\UpdateHabitRequest;
use App\Http\Resources\HabitResource;
use App\Models\Habit;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class HabitController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $this->authorize('viewAny', Habit::class);

        $paginator = $request->user()->habits()->orderByDesc('created_at')->paginate(15);
        $paginator->through(fn (Habit $h) => (new HabitResource($h))->resolve());

        return $this->successResponse(
            $paginator->items(),
            'Habit list fetched successfully.',
            [
                'current_page' => $paginator->currentPage(),
                'last_page' => $paginator->lastPage(),
                'per_page' => $paginator->perPage(),
                'total' => $paginator->total(),
            ]
        );
    }

    public function store(StoreHabitRequest $request): JsonResponse
    {
        $this->authorize('create', Habit::class);

        $data = $request->validated();
        if (! array_key_exists('target_count', $data) || $data['target_count'] === null) {
            $data['target_count'] = 1;
        }

        $habit = $request->user()->habits()->create($data);

        return $this->successResponse(new HabitResource($habit), 'Habit created successfully.', null, 201);
    }

    public function show(Request $request, Habit $habit): JsonResponse
    {
        $this->authorize('view', $habit);

        return $this->successResponse(new HabitResource($habit), 'Habit fetched successfully.');
    }

    public function update(UpdateHabitRequest $request, Habit $habit): JsonResponse
    {
        $this->authorize('update', $habit);

        $habit->update($request->validated());

        return $this->successResponse(new HabitResource($habit->fresh()), 'Habit updated successfully.');
    }

    public function destroy(Request $request, Habit $habit): JsonResponse
    {
        $this->authorize('delete', $habit);

        $habit->delete();

        return $this->successResponse(null, 'Habit deleted successfully.');
    }
}
