<?php

namespace Tests\Feature\Api;

use App\Models\Task;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class DashboardTest extends TestCase
{
    use RefreshDatabase;

    public function test_dashboard_returns_summary_for_authenticated_user(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);

        $response = $this->getJson('/api/dashboard');

        $response->assertOk()
            ->assertJsonPath('success', true)
            ->assertJsonStructure([
                'data' => [
                    'total_tasks',
                    'completed_tasks',
                    'pending_tasks',
                    'in_progress_tasks',
                    'active_habits_count',
                    'today_habit_logs_count',
                    'journal_entries_count',
                    'latest_habit_activity',
                    'latest_journal_entry',
                    'latest_mood_entry',
                    'average_mood_last_7_days',
                    'recent_tasks',
                    'recent_journal_entries',
                    'recent_mood_entries',
                ],
            ]);
    }

    public function test_dashboard_counts_only_authenticated_users_data(): void
    {
        $owner = User::factory()->create();
        Task::factory()->count(4)->for($owner)->create(['status' => 'completed']);

        $viewer = User::factory()->create();
        Sanctum::actingAs($viewer);

        $this->getJson('/api/dashboard')
            ->assertOk()
            ->assertJsonPath('data.total_tasks', 0)
            ->assertJsonPath('data.completed_tasks', 0);
    }
}
