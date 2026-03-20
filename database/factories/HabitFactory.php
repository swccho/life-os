<?php

namespace Database\Factories;

use App\Models\Habit;
use App\Models\User;
use Illuminate\Database\Eloquent\Factories\Factory;

/**
 * @extends Factory<Habit>
 */
class HabitFactory extends Factory
{
    protected $model = Habit::class;

    /**
     * @return array<string, mixed>
     */
    public function definition(): array
    {
        return [
            'user_id' => User::factory(),
            'name' => fake()->words(2, true).' habit',
            'description' => fake()->optional()->sentence(),
            'frequency_type' => fake()->randomElement(['daily', 'weekly']),
            'target_count' => fake()->numberBetween(1, 3),
            'is_active' => true,
        ];
    }
}
