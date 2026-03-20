<?php

namespace App\Http\Controllers\Api\Journal;

use App\Http\Controllers\Controller;
use App\Http\Requests\Journal\StoreJournalEntryRequest;
use App\Http\Requests\Journal\UpdateJournalEntryRequest;
use App\Http\Resources\JournalEntryResource;
use App\Models\JournalEntry;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class JournalController extends Controller
{
    public function index(Request $request): JsonResponse
    {
        $this->authorize('viewAny', JournalEntry::class);

        $query = $request->user()->journalEntries();

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
        $paginator->through(fn (JournalEntry $e) => (new JournalEntryResource($e))->resolve());

        return $this->successResponse(
            $paginator->items(),
            'Journal entries fetched successfully.',
            [
                'current_page' => $paginator->currentPage(),
                'last_page' => $paginator->lastPage(),
                'per_page' => $paginator->perPage(),
                'total' => $paginator->total(),
            ]
        );
    }

    public function store(StoreJournalEntryRequest $request): JsonResponse
    {
        $this->authorize('create', JournalEntry::class);

        $entry = $request->user()->journalEntries()->create($request->validated());

        return $this->successResponse(new JournalEntryResource($entry), 'Journal entry created successfully.', null, 201);
    }

    public function show(Request $request, JournalEntry $journal_entry): JsonResponse
    {
        $this->authorize('view', $journal_entry);

        return $this->successResponse(new JournalEntryResource($journal_entry), 'Journal entry fetched successfully.');
    }

    public function update(UpdateJournalEntryRequest $request, JournalEntry $journal_entry): JsonResponse
    {
        $this->authorize('update', $journal_entry);

        $journal_entry->update($request->validated());

        return $this->successResponse(new JournalEntryResource($journal_entry->fresh()), 'Journal entry updated successfully.');
    }

    public function destroy(Request $request, JournalEntry $journal_entry): JsonResponse
    {
        $this->authorize('delete', $journal_entry);

        $journal_entry->delete();

        return $this->successResponse(null, 'Journal entry deleted successfully.');
    }
}
