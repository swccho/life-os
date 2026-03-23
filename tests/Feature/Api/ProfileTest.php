<?php

namespace Tests\Feature\Api;

use App\Models\User;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Laravel\Sanctum\Sanctum;
use Tests\TestCase;

class ProfileTest extends TestCase
{
    use RefreshDatabase;

    public function test_profile_update_requires_authentication(): void
    {
        $this->patchJson('/api/profile', [
            'name' => 'Updated',
        ])->assertUnauthorized();
    }

    public function test_profile_update_updates_name_and_bio(): void
    {
        $user = User::factory()->create(['name' => 'Old Name', 'bio' => null]);
        Sanctum::actingAs($user);

        $response = $this->patchJson('/api/profile', [
            'name' => 'New Name',
            'bio' => 'Builder of calm systems.',
        ]);

        $response->assertOk()
            ->assertJsonPath('success', true)
            ->assertJsonPath('data.user.name', 'New Name')
            ->assertJsonPath('data.user.bio', 'Builder of calm systems.');

        $this->assertDatabaseHas('users', [
            'id' => $user->id,
            'name' => 'New Name',
            'bio' => 'Builder of calm systems.',
        ]);
    }

    public function test_profile_update_allows_null_bio(): void
    {
        $user = User::factory()->create(['bio' => 'Was here']);
        Sanctum::actingAs($user);

        $this->patchJson('/api/profile', [
            'name' => $user->name,
            'bio' => null,
        ])->assertOk()
            ->assertJsonPath('data.user.bio', null);
    }

    public function test_profile_update_validates_name_required(): void
    {
        Sanctum::actingAs(User::factory()->create());

        $this->patchJson('/api/profile', [
            'name' => '',
        ])->assertUnprocessable()
            ->assertJsonPath('success', false);
    }
}
