<?php

namespace App\Http\Controllers\Api\Habits;

use App\Http\Concerns\DetectsUniqueConstraintViolations;
use App\Http\Controllers\Controller;
use App\Http\Requests\Habits\StoreHabitLogRequest;
use App\Http\Resources\HabitLogResource;
use App\Models\Habit;
use App\Models\HabitLog;
use Illuminate\Database\QueryException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class HabitLogController extends Controller
{
    use DetectsUniqueConstraintViolations;

    public function index(Request $request, Habit $habit): JsonResponse
    {
        $this->authorize('view', $habit);

        $paginator = $habit->habitLogs()
            ->where('user_id', $request->user()->id)
            ->orderByDesc('logged_date')
            ->orderByDesc('id')
            ->paginate(15);

        $paginator->through(fn (HabitLog $l) => (new HabitLogResource($l))->resolve());

        return $this->successResponse(
            $paginator->items(),
            'Habit logs fetched successfully.',
            [
                'current_page' => $paginator->currentPage(),
                'last_page' => $paginator->lastPage(),
                'per_page' => $paginator->perPage(),
                'total' => $paginator->total(),
            ]
        );
    }

    public function store(StoreHabitLogRequest $request, Habit $habit): JsonResponse
    {
        $this->authorize('view', $habit);

        try {
            $log = HabitLog::query()->create([
                'habit_id' => $habit->id,
                'user_id' => $request->user()->id,
                'logged_date' => $request->validated('logged_date'),
                'count' => $request->validated('count', 1),
                'notes' => $request->validated('notes'),
            ]);
        } catch (QueryException $e) {
            if ($this->isUniqueConstraintViolation($e)) {
                return $this->errorResponse('A log for this habit and date already exists.', null, 409);
            }

            throw $e;
        }

        return $this->successResponse(new HabitLogResource($log), 'Habit log created successfully.', null, 201);
    }

    public function destroy(Request $request, HabitLog $habit_log): JsonResponse
    {
        $this->authorize('delete', $habit_log);

        $habit_log->delete();

        return $this->successResponse(null, 'Habit log deleted successfully.');
    }
}
