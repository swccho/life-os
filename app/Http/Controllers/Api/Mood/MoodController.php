<?php

namespace App\Http\Controllers\Api\Mood;

use App\Http\Concerns\DetectsUniqueConstraintViolations;
use App\Http\Controllers\Controller;
use App\Http\Requests\Mood\StoreMoodEntryRequest;
use App\Http\Requests\Mood\UpdateMoodEntryRequest;
use App\Http\Resources\MoodEntryResource;
use App\Models\MoodEntry;
use Illuminate\Database\QueryException;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class MoodController extends Controller
{
    use DetectsUniqueConstraintViolations;

    public function index(Request $request): JsonResponse
    {
        $this->authorize('viewAny', MoodEntry::class);

        $query = $request->user()->moodEntries();

        if ($request->filled('entry_date')) {
            $query->whereDate('entry_date', $request->query('entry_date'));
        }

        if ($request->filled('from')) {
            $query->whereDate('entry_date', '>=', $request->query('from'));
        }

        if ($request->filled('to')) {
            $query->whereDate('entry_date', '<=', $request->query('to'));
        }

        $paginator = $query->orderByDesc('entry_date')->orderByDesc('id')->paginate(15);
        $paginator->through(fn (MoodEntry $e) => (new MoodEntryResource($e))->resolve());

        return $this->successResponse(
            $paginator->items(),
            'Mood entries fetched successfully.',
            [
                'current_page' => $paginator->currentPage(),
                'last_page' => $paginator->lastPage(),
                'per_page' => $paginator->perPage(),
                'total' => $paginator->total(),
            ]
        );
    }

    public function store(StoreMoodEntryRequest $request): JsonResponse
    {
        $this->authorize('create', MoodEntry::class);

        try {
            $entry = $request->user()->moodEntries()->create($request->validated());
        } catch (QueryException $e) {
            if ($this->isUniqueConstraintViolation($e)) {
                return $this->errorResponse('A mood entry for this date already exists.', null, 409);
            }

            throw $e;
        }

        return $this->successResponse(new MoodEntryResource($entry), 'Mood entry created successfully.', null, 201);
    }

    public function show(Request $request, MoodEntry $mood_entry): JsonResponse
    {
        $this->authorize('view', $mood_entry);

        return $this->successResponse(new MoodEntryResource($mood_entry), 'Mood entry fetched successfully.');
    }

    public function update(UpdateMoodEntryRequest $request, MoodEntry $mood_entry): JsonResponse
    {
        $this->authorize('update', $mood_entry);

        try {
            $mood_entry->update($request->validated());
        } catch (QueryException $e) {
            if ($this->isUniqueConstraintViolation($e)) {
                return $this->errorResponse('A mood entry for this date already exists.', null, 409);
            }

            throw $e;
        }

        return $this->successResponse(new MoodEntryResource($mood_entry->fresh()), 'Mood entry updated successfully.');
    }

    public function destroy(Request $request, MoodEntry $mood_entry): JsonResponse
    {
        $this->authorize('delete', $mood_entry);

        $mood_entry->delete();

        return $this->successResponse(null, 'Mood entry deleted successfully.');
    }
}
