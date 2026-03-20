<?php

namespace App\Http\Controllers\Api\Tasks;

use App\Http\Controllers\Controller;
use App\Http\Requests\Tasks\StoreTaskRequest;
use App\Http\Requests\Tasks\UpdateTaskRequest;
use App\Http\Resources\TaskResource;
use App\Models\Task;
use App\Services\TaskListingService;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

class TaskController extends Controller
{
    public function __construct(
        private readonly TaskListingService $taskListingService
    ) {}

    public function index(Request $request): JsonResponse
    {
        $this->authorize('viewAny', Task::class);

        $paginator = $this->taskListingService->paginatedForUser($request->user(), $request);
        $paginator->through(fn (Task $task) => (new TaskResource($task))->resolve());

        return $this->successResponse(
            $paginator->items(),
            'Task list fetched successfully.',
            [
                'current_page' => $paginator->currentPage(),
                'last_page' => $paginator->lastPage(),
                'per_page' => $paginator->perPage(),
                'total' => $paginator->total(),
            ]
        );
    }

    public function store(StoreTaskRequest $request): JsonResponse
    {
        $this->authorize('create', Task::class);

        $task = $request->user()->tasks()->create($request->validated());

        return $this->successResponse(new TaskResource($task), 'Task created successfully.', null, 201);
    }

    public function show(Request $request, Task $task): JsonResponse
    {
        $this->authorize('view', $task);

        return $this->successResponse(new TaskResource($task), 'Task fetched successfully.');
    }

    public function update(UpdateTaskRequest $request, Task $task): JsonResponse
    {
        $this->authorize('update', $task);

        $task->update($request->validated());

        return $this->successResponse(new TaskResource($task->fresh()), 'Task updated successfully.');
    }

    public function destroy(Request $request, Task $task): JsonResponse
    {
        $this->authorize('delete', $task);

        $task->delete();

        return $this->successResponse(null, 'Task deleted successfully.');
    }
}
