<?php

namespace Tests\Feature\Api;

use App\Models\Habit;
use App\Models\HabitLog;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class HabitTest extends TestCase
{
    use RefreshDatabase;

    public function test_authenticated_user_can_create_habit(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);

        $response = $this->postJson('/api/habits', [
            'name' => 'Meditate',
            'description' => '10 minutes',
            'frequency_type' => 'daily',
            'target_count' => 1,
            'is_active' => true,
        ]);

        $response->assertCreated()
            ->assertJsonPath('data.name', 'Meditate');

        $this->assertDatabaseHas('habits', [
            'user_id' => $user->id,
            'name' => 'Meditate',
        ]);
    }

    public function test_authenticated_user_can_list_own_habits(): void
    {
        $user = User::factory()->create();
        Habit::factory()->count(2)->for($user)->create();

        Sanctum::actingAs($user);

        $this->getJson('/api/habits')
            ->assertOk()
            ->assertJsonCount(2, 'data')
            ->assertJsonStructure(['meta' => ['current_page', 'last_page', 'per_page', 'total']]);
    }

    public function test_validation_fails_for_invalid_habit_frequency_type(): void
    {
        Sanctum::actingAs(User::factory()->create());

        $this->postJson('/api/habits', [
            'name' => 'Run',
            'frequency_type' => 'hourly',
        ])->assertUnprocessable()
            ->assertJsonPath('success', false);
    }

    public function test_user_can_update_own_habit(): void
    {
        $user = User::factory()->create();
        $habit = Habit::factory()->for($user)->create(['name' => 'Old']);

        Sanctum::actingAs($user);

        $this->patchJson('/api/habits/'.$habit->id, [
            'name' => 'Updated habit',
        ])->assertOk()
            ->assertJsonPath('data.name', 'Updated habit');
    }

    public function test_user_can_delete_own_habit(): void
    {
        $user = User::factory()->create();
        $habit = Habit::factory()->for($user)->create();

        Sanctum::actingAs($user);

        $this->deleteJson('/api/habits/'.$habit->id)->assertOk();

        $this->assertDatabaseMissing('habits', ['id' => $habit->id]);
    }

    public function test_user_cannot_view_another_users_habit(): void
    {
        $owner = User::factory()->create();
        $other = User::factory()->create();
        $habit = Habit::factory()->for($owner)->create();

        Sanctum::actingAs($other);

        $this->getJson('/api/habits/'.$habit->id)->assertForbidden();
    }

    public function test_authenticated_user_can_list_habit_logs(): void
    {
        $user = User::factory()->create();
        $habit = Habit::factory()->for($user)->create();
        $date = Carbon::today()->toDateString();
        HabitLog::query()->create([
            'habit_id' => $habit->id,
            'user_id' => $user->id,
            'logged_date' => $date,
            'count' => 1,
        ]);

        Sanctum::actingAs($user);

        $this->getJson('/api/habits/'.$habit->id.'/logs')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonStructure(['meta' => ['current_page', 'last_page', 'per_page', 'total']]);
    }

    public function test_user_can_delete_own_habit_log(): void
    {
        $user = User::factory()->create();
        $habit = Habit::factory()->for($user)->create();
        $log = HabitLog::query()->create([
            'habit_id' => $habit->id,
            'user_id' => $user->id,
            'logged_date' => Carbon::today()->toDateString(),
            'count' => 1,
        ]);

        Sanctum::actingAs($user);

        $this->deleteJson('/api/habit-logs/'.$log->id)->assertOk();

        $this->assertDatabaseMissing('habit_logs', ['id' => $log->id]);
    }

    public function test_user_cannot_list_logs_for_another_users_habit(): void
    {
        $owner = User::factory()->create();
        $other = User::factory()->create();
        $habit = Habit::factory()->for($owner)->create();

        Sanctum::actingAs($other);

        $this->getJson('/api/habits/'.$habit->id.'/logs')->assertForbidden();
    }

    public function test_user_cannot_delete_another_users_habit_log(): void
    {
        $owner = User::factory()->create();
        $other = User::factory()->create();
        $habit = Habit::factory()->for($owner)->create();
        $log = HabitLog::query()->create([
            'habit_id' => $habit->id,
            'user_id' => $owner->id,
            'logged_date' => Carbon::today()->toDateString(),
            'count' => 1,
        ]);

        Sanctum::actingAs($other);

        $this->deleteJson('/api/habit-logs/'.$log->id)->assertForbidden();
    }

    public function test_authenticated_user_can_log_habit(): void
    {
        $user = User::factory()->create();
        $habit = Habit::factory()->for($user)->create();
        Sanctum::actingAs($user);

        $date = Carbon::today()->toDateString();

        $response = $this->postJson('/api/habits/'.$habit->id.'/logs', [
            'logged_date' => $date,
            'count' => 1,
        ]);

        $response->assertCreated()
            ->assertJsonPath('data.logged_date', $date);
    }

    public function test_duplicate_habit_log_for_same_date_returns_conflict(): void
    {
        $user = User::factory()->create();
        $habit = Habit::factory()->for($user)->create();
        Sanctum::actingAs($user);

        $date = Carbon::today()->toDateString();

        HabitLog::query()->create([
            'habit_id' => $habit->id,
            'user_id' => $user->id,
            'logged_date' => $date,
            'count' => 1,
        ]);

        $this->postJson('/api/habits/'.$habit->id.'/logs', [
            'logged_date' => $date,
            'count' => 1,
        ])->assertStatus(409)
            ->assertJsonPath('success', false);
    }
}
