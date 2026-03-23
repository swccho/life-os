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
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

/**
 * Populates domain tables, Sanctum tokens, and minimal framework rows for local/demo use.
 *
 * Demo: demo@lifeos.test / password — Second user: alex@lifeos.test / password
 *
 * Intentionally not seeded: sessions, jobs, job_batches (runtime / awkward payloads).
 */
class DummyDataSeeder extends Seeder
{
    public function run(): void
    {
        $demo = $this->seedDemoUser();
        $this->seedSanctumToken($demo);
        $this->seedDemoUserDomainData($demo);

        $other = $this->seedSecondUser();
        $this->seedSecondUserDomainData($other);

        $this->seedFrameworkTables();
    }

    private function seedDemoUser(): User
    {
        return User::factory()->create([
            'name' => 'Demo User',
            'email' => 'demo@lifeos.test',
            'password' => 'password',
            'bio' => 'Building calm routines, one day at a time.',
        ]);
    }

    private function seedSecondUser(): User
    {
        return User::factory()->create([
            'name' => 'Alex Rivera',
            'email' => 'alex@lifeos.test',
            'password' => 'password',
            'bio' => 'Second account for multi-user checks.',
        ]);
    }

    private function seedSanctumToken(User $demo): void
    {
        $token = $demo->createToken('dummy-seed');
        if ($this->command) {
            $this->command->info('Sanctum dummy token (demo user): '.$token->plainTextToken);
        }
    }

    private function seedDemoUserDomainData(User $demo): void
    {
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

    private function seedSecondUserDomainData(User $user): void
    {
        Task::factory()
            ->count(3)
            ->for($user)
            ->sequence(
                ['title' => 'Alex: inbox zero', 'status' => 'pending', 'priority' => 'medium'],
                ['title' => 'Alex: walk the dog', 'status' => 'completed', 'priority' => 'low', 'completed_at' => now()->subHours(4)],
                ['title' => 'Alex: budget review', 'status' => 'in_progress', 'priority' => 'high'],
            )
            ->create();

        $h = Habit::factory()->for($user)->create([
            'name' => 'Evening walk',
            'frequency_type' => 'daily',
            'target_count' => 1,
        ]);

        foreach (range(0, 2) as $dayOffset) {
            HabitLog::query()->create([
                'habit_id' => $h->id,
                'user_id' => $user->id,
                'logged_date' => Carbon::today()->subDays($dayOffset)->toDateString(),
                'count' => 1,
            ]);
        }

        foreach (range(0, 4) as $i) {
            JournalEntry::factory()->for($user)->create([
                'entry_date' => Carbon::today()->subDays($i + 2)->toDateString(),
                'title' => $i === 0 ? 'Quick note' : null,
                'content' => 'Short journal line from the second seeded user.',
            ]);
        }

        foreach (range(0, 4) as $dayOffset) {
            MoodEntry::query()->create([
                'user_id' => $user->id,
                'mood_score' => 3 + ($dayOffset % 3),
                'mood_label' => ['okay', 'good', 'great'][$dayOffset % 3],
                'entry_date' => Carbon::today()->subDays($dayOffset + 10)->toDateString(),
            ]);
        }
    }

    private function seedFrameworkTables(): void
    {
        DB::table('password_reset_tokens')->insert([
            'email' => 'seed-reset@lifeos.test',
            'token' => Hash::make('seed-token'),
            'created_at' => now(),
        ]);

        DB::table('cache')->insert([
            'key' => 'seed:dummy',
            'value' => serialize('1'),
            'expiration' => now()->addHour()->timestamp,
        ]);

        DB::table('cache_locks')->insert([
            'key' => 'seed:lock',
            'owner' => Str::random(40),
            'expiration' => now()->addMinutes(30)->timestamp,
        ]);

        DB::table('failed_jobs')->insert([
            'uuid' => (string) Str::uuid(),
            'connection' => 'database',
            'queue' => 'default',
            'payload' => json_encode(['job' => 'SeededFailedJob', 'data' => []]),
            'exception' => "Seeded dummy failed job — not a real exception.\n",
            'failed_at' => now(),
        ]);
    }
}
