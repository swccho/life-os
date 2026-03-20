<?php

namespace Database\Factories;

use App\Models\JournalEntry;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<JournalEntry>
 */
class JournalEntryFactory extends Factory
{
    protected $model = JournalEntry::class;

    /**
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'title' => fake()->optional()->sentence(4),
            'content' => fake()->paragraphs(2, true),
            'entry_date' => fake()->dateTimeBetween('-14 days', 'now')->format('Y-m-d'),
        ];
    }
}
