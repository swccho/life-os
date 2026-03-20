<?php

namespace Tests\Feature\Api;

use App\Models\JournalEntry;
use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class JournalTest extends TestCase
{
    use RefreshDatabase;

    public function test_authenticated_user_can_create_journal_entry(): void
    {
        $user = User::factory()->create();
        Sanctum::actingAs($user);

        $response = $this->postJson('/api/journal-entries', [
            'title' => 'Morning pages',
            'content' => 'Long form content here.',
            'entry_date' => '2026-03-15',
        ]);

        $response->assertCreated()
            ->assertJsonPath('data.content', 'Long form content here.');

        $this->assertDatabaseHas('journal_entries', ['user_id' => $user->id]);
        $this->assertSame(
            1,
            JournalEntry::query()->where('user_id', $user->id)->whereDate('entry_date', '2026-03-15')->count()
        );
    }

    public function test_user_cannot_access_another_users_journal_entry(): void
    {
        $owner = User::factory()->create();
        $other = User::factory()->create();
        $entry = JournalEntry::factory()->for($owner)->create();

        Sanctum::actingAs($other);

        $this->getJson('/api/journal-entries/'.$entry->id)->assertForbidden();
    }

    public function test_authenticated_user_can_list_journal_entries_filtered_by_date(): void
    {
        $user = User::factory()->create();
        JournalEntry::factory()->for($user)->create(['entry_date' => '2026-03-10']);
        JournalEntry::factory()->for($user)->create(['entry_date' => '2026-03-15']);

        Sanctum::actingAs($user);

        $this->getJson('/api/journal-entries?entry_date=2026-03-15')
            ->assertOk()
            ->assertJsonCount(1, 'data')
            ->assertJsonPath('data.0.entry_date', '2026-03-15')
            ->assertJsonStructure(['meta' => ['current_page', 'last_page', 'per_page', 'total']]);
    }

    public function test_user_can_update_own_journal_entry(): void
    {
        $user = User::factory()->create();
        $entry = JournalEntry::factory()->for($user)->create(['title' => 'Old']);

        Sanctum::actingAs($user);

        $this->patchJson('/api/journal-entries/'.$entry->id, [
            'title' => 'Revised',
        ])->assertOk()
            ->assertJsonPath('data.title', 'Revised');
    }

    public function test_user_can_delete_own_journal_entry(): void
    {
        $user = User::factory()->create();
        $entry = JournalEntry::factory()->for($user)->create();

        Sanctum::actingAs($user);

        $this->deleteJson('/api/journal-entries/'.$entry->id)->assertOk();

        $this->assertDatabaseMissing('journal_entries', ['id' => $entry->id]);
    }

    public function test_user_cannot_update_another_users_journal_entry(): void
    {
        $owner = User::factory()->create();
        $other = User::factory()->create();
        $entry = JournalEntry::factory()->for($owner)->create();

        Sanctum::actingAs($other);

        $this->patchJson('/api/journal-entries/'.$entry->id, [
            'title' => 'Hacked',
        ])->assertForbidden();
    }
}
