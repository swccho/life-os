<?php

namespace Tests\Feature\Api;

use App\Models\MoodEntry;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class MoodTest extends TestCase
{
    use RefreshDatabase;

    public function test_authenticated_user_can_create_mood_entry(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);

        $date = Carbon::today()->toDateString();

        $response = $this->postJson('/api/mood-entries', [
            'mood_score' => 4,
            'mood_label' => 'calm',
            'entry_date' => $date,
        ]);

        $response->assertCreated()
            ->assertJsonPath('data.mood_score', 4);
    }

    public function test_duplicate_mood_entry_for_same_date_returns_conflict(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);

        $date = Carbon::today()->toDateString();

        MoodEntry::query()->create([
            'user_id' => $user->id,
            'mood_score' => 3,
            'entry_date' => $date,
        ]);

        $this->postJson('/api/mood-entries', [
            'mood_score' => 5,
            'entry_date' => $date,
        ])->assertStatus(409)
            ->assertJsonPath('success', false);
    }

    public function test_validation_fails_for_invalid_mood_score(): void
    {
        Sanctum::actingAs(User::factory()->create());

        $this->postJson('/api/mood-entries', [
            'mood_score' => 10,
            'entry_date' => Carbon::today()->toDateString(),
        ])->assertUnprocessable()
            ->assertJsonPath('success', false);
    }

    public function test_user_cannot_view_another_users_mood_entry(): void
    {
        $owner = User::factory()->create();
        $other = User::factory()->create();
        $entry = MoodEntry::factory()->for($owner)->create();

        Sanctum::actingAs($other);

        $this->getJson('/api/mood-entries/'.$entry->id)->assertForbidden();
    }

    public function test_authenticated_user_can_list_mood_entries_filtered_by_date(): void
    {
        $user = User::factory()->create();
        MoodEntry::factory()->for($user)->create(['entry_date' => '2026-02-01', 'mood_score' => 2]);
        MoodEntry::factory()->for($user)->create(['entry_date' => '2026-02-10', 'mood_score' => 4]);

        Sanctum::actingAs($user);

        $this->getJson('/api/mood-entries?entry_date=2026-02-10')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.mood_score', 4)
            ->assertJsonStructure(['meta' => ['current_page', 'last_page', 'per_page', 'total']]);
    }

    public function test_user_can_update_own_mood_entry(): void
    {
        $user = User::factory()->create();
        $date = Carbon::today()->toDateString();
        $entry = MoodEntry::factory()->for($user)->create([
            'entry_date' => $date,
            'mood_score' => 2,
        ]);

        Sanctum::actingAs($user);

        $this->patchJson('/api/mood-entries/'.$entry->id, [
            'mood_score' => 5,
        ])->assertOk()
            ->assertJsonPath('data.mood_score', 5);
    }

    public function test_user_can_delete_own_mood_entry(): void
    {
        $user = User::factory()->create();
        $entry = MoodEntry::factory()->for($user)->create([
            'entry_date' => Carbon::today()->toDateString(),
        ]);

        Sanctum::actingAs($user);

        $this->deleteJson('/api/mood-entries/'.$entry->id)->assertOk();

        $this->assertDatabaseMissing('mood_entries', ['id' => $entry->id]);
    }

    public function test_updating_mood_entry_to_duplicate_date_returns_conflict(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);

        MoodEntry::factory()->for($user)->create([
            'entry_date' => '2026-04-01',
            'mood_score' => 3,
        ]);
        $second = MoodEntry::factory()->for($user)->create([
            'entry_date' => '2026-04-02',
            'mood_score' => 4,
        ]);

        $this->patchJson('/api/mood-entries/'.$second->id, [
            'entry_date' => '2026-04-01',
        ])->assertStatus(409)
            ->assertJsonPath('success', false);
    }
}
