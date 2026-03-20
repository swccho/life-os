<?php

namespace App\Services;

use App\Models\User;
use Illuminate\Contracts\Pagination\LengthAwarePaginator;
use Illuminate\Http\Request;

class TaskListingService
{
    public function paginatedForUser(User $user, Request $request): LengthAwarePaginator
    {
        $query = $user->tasks();

        if ($request->filled('status')) {
            $query->where('status', $request->query('status'));
        }

        if ($request->filled('priority')) {
            $query->where('priority', $request->query('priority'));
        }

        $sort = $request->query('sort', 'created_at');
        if (! in_array($sort, ['due_date', 'created_at'], true)) {
            $sort = 'created_at';
        }

        $direction = strtolower((string) $request->query('direction', 'desc')) === 'asc' ? 'asc' : 'desc';
        $query->orderBy($sort, $direction);

        return $query->paginate(15);
    }
}
