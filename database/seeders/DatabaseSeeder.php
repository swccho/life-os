<?php

namespace Database\Seeders;

use App\Models\Habit;
use App\Models\HabitLog;
use App\Models\JournalEntry;
use App\Models\MoodEntry;
use App\Models\Task;
use App\Models\User;
use Carbon\Carbon;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Demo account: demo@lifeos.test / password
     */
    public function run(): void
    {
        $demo = User::factory()->create([
            'name' => 'Demo User',
            'email' => 'demo@lifeos.test',
            'password' => 'password',
        ]);

        Task::factory()
            ->count(8)
            ->for($demo)
            ->sequence(
                ['title' => 'Review weekly goals', 'status' => 'pending', 'priority' => 'high'],
                ['title' => 'Morning workout', 'status' => 'in_progress', 'priority' => 'medium'],
                ['title' => 'Read for 20 minutes', 'status' => 'completed', 'priority' => 'low', 'completed_at' => now()->subDay()],
                ['title' => 'Plan meals', 'status' => 'pending', 'priority' => 'medium'],
                ['title' => 'Call dentist', 'status' => 'pending', 'priority' => 'high', 'due_date' => now()->addDays(3)],
                ['title' => 'Update LifeOS tasks', 'status' => 'in_progress', 'priority' => 'high'],
                ['title' => 'Water plants', 'status' => 'completed', 'priority' => 'low', 'completed_at' => now()->subHours(2)],
                ['title' => 'Journal reflection', 'status' => 'pending', 'priority' => 'low'],
            )
            ->create();

        $habits = collect([
            ['name' => 'Morning stretch', 'frequency_type' => 'daily', 'target_count' => 1],
            ['name' => 'Drink water', 'frequency_type' => 'daily', 'target_count' => 3],
            ['name' => 'Weekly review', 'frequency_type' => 'weekly', 'target_count' => 1],
        ])->map(fn (array $data) => Habit::factory()->for($demo)->create($data));

        foreach ($habits as $habit) {
            foreach (range(0, 5) as $dayOffset) {
                HabitLog::query()->create([
                    'habit_id' => $habit->id,
                    'user_id' => $demo->id,
                    'logged_date' => Carbon::today()->subDays($dayOffset)->toDateString(),
                    'count' => 1,
                    'notes' => $dayOffset === 0 ? 'Feeling good today.' : null,
                ]);
            }
        }

        foreach (range(0, 9) as $i) {
            JournalEntry::factory()->for($demo)->create([
                'entry_date' => Carbon::today()->subDays($i)->toDateString(),
                'title' => $i % 3 === 0 ? 'Day '.$i.' reflection' : null,
                'content' => 'Today I focused on small wins and tracked my habits consistently.',
            ]);
        }

        foreach (range(0, 6) as $dayOffset) {
            MoodEntry::query()->create([
                'user_id' => $demo->id,
                'mood_score' => ($dayOffset % 5) + 1,
                'mood_label' => ['calm', 'focused', 'happy', 'tired', 'stressed'][$dayOffset % 5],
                'notes' => $dayOffset === 0 ? 'Steady day overall.' : null,
                'entry_date' => Carbon::today()->subDays($dayOffset)->toDateString(),
            ]);
        }
    }
}
