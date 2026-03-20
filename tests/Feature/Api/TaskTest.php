<?php

namespace Tests\Feature\Api;

use App\Models\Task;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class TaskTest extends TestCase
{
    use RefreshDatabase;

    public function test_authenticated_user_can_list_their_tasks(): void
    {
        $user = User::factory()->create();
        Task::factory()->count(2)->for($user)->create();

        Sanctum::actingAs($user);

        $response = $this->getJson('/api/tasks');

        $response->assertOk()
            ->assertJsonPath('success', true)
            ->assertJsonCount(2, 'data')
            ->assertJsonStructure(['meta' => ['current_page', 'last_page', 'per_page', 'total']]);
    }

    public function test_task_list_excludes_other_users_tasks(): void
    {
        $user = User::factory()->create();
        $other = User::factory()->create();
        Task::factory()->count(3)->for($other)->create();
        Task::factory()->count(2)->for($user)->create();

        Sanctum::actingAs($user);

        $this->getJson('/api/tasks')
            ->assertOk()
            ->assertJsonCount(2, 'data')
            ->assertJsonPath('meta.total', 2);
    }

    public function test_authenticated_user_can_create_task(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);

        $response = $this->postJson('/api/tasks', [
            'title' => 'Write tests',
            'description' => 'Cover critical flows',
            'status' => 'pending',
            'priority' => 'high',
        ]);

        $response->assertCreated()
            ->assertJsonPath('data.title', 'Write tests');

        $this->assertDatabaseHas('tasks', [
            'user_id' => $user->id,
            'title' => 'Write tests',
        ]);
    }

    public function test_validation_fails_for_invalid_task_data(): void
    {
        Sanctum::actingAs(User::factory()->create());

        $this->postJson('/api/tasks', [
            'title' => '',
        ])->assertUnprocessable()
            ->assertJsonPath('success', false);
    }

    public function test_validation_fails_for_invalid_task_status(): void
    {
        Sanctum::actingAs(User::factory()->create());

        $this->postJson('/api/tasks', [
            'title' => 'Valid title',
            'status' => 'not_a_real_status',
        ])->assertUnprocessable()
            ->assertJsonPath('success', false);
    }

    public function test_user_cannot_access_another_users_task(): void
    {
        $owner = User::factory()->create();
        $other = User::factory()->create();
        $task = Task::factory()->for($owner)->create();

        Sanctum::actingAs($other);

        $this->getJson('/api/tasks/'.$task->id)->assertForbidden();
    }

    public function test_user_can_update_own_task(): void
    {
        $user = User::factory()->create();
        $task = Task::factory()->for($user)->create(['title' => 'Old']);

        Sanctum::actingAs($user);

        $this->patchJson('/api/tasks/'.$task->id, [
            'title' => 'Updated',
        ])->assertOk()
            ->assertJsonPath('data.title', 'Updated');
    }

    public function test_user_can_delete_own_task(): void
    {
        $user = User::factory()->create();
        $task = Task::factory()->for($user)->create();

        Sanctum::actingAs($user);

        $this->deleteJson('/api/tasks/'.$task->id)->assertOk();

        $this->assertDatabaseMissing('tasks', ['id' => $task->id]);
    }
}
