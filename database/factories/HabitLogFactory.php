<?php

namespace Database\Factories;

use App\Models\Habit;
use App\Models\HabitLog;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<HabitLog>
 */
class HabitLogFactory extends Factory
{
    protected $model = HabitLog::class;

    /**
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'habit_id' => Habit::factory(),
            'user_id' => User::factory(),
            'logged_date' => fake()->date(),
            'count' => fake()->numberBetween(1, 2),
            'notes' => fake()->optional()->sentence(),
        ];
    }
}
