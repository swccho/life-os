<?php

namespace App\Services;

use App\Models\User;
use Carbon\Carbon;

class DashboardService
{
    /**
     * @return array<string, mixed>
     */
    public function buildSummary(User $user): array
    {
        $taskBase = $user->tasks();

        $taskRow = (clone $taskBase)->selectRaw("
            COUNT(*) as total_tasks,
            COALESCE(SUM(CASE WHEN status = 'completed' THEN 1 ELSE 0 END), 0) as completed_tasks,
            COALESCE(SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END), 0) as pending_tasks,
            COALESCE(SUM(CASE WHEN status = 'in_progress' THEN 1 ELSE 0 END), 0) as in_progress_tasks
        ")->first();

        $totalTasks = (int) ($taskRow?->total_tasks ?? 0);
        $completedTasks = (int) ($taskRow?->completed_tasks ?? 0);
        $pendingTasks = (int) ($taskRow?->pending_tasks ?? 0);
        $inProgressTasks = (int) ($taskRow?->in_progress_tasks ?? 0);

        $activeHabitsCount = $user->habits()->where('is_active', true)->count();

        $today = Carbon::today();
        $todayHabitLogsCount = $user->habitLogs()
            ->whereDate('logged_date', $today)
            ->count();

        $latestJournalEntry = $user->journalEntries()
            ->orderByDesc('entry_date')
            ->orderByDesc('id')
            ->first();

        $latestMoodEntry = $user->moodEntries()
            ->orderByDesc('entry_date')
            ->orderByDesc('id')
            ->first();

        $avgMood = $user->moodEntries()
            ->where('entry_date', '>=', $today->copy()->subDays(6)->toDateString())
            ->avg('mood_score');

        $recentTasks = $user->tasks()
            ->orderByDesc('updated_at')
            ->limit(5)
            ->get();

        $recentJournalEntries = $user->journalEntries()
            ->orderByDesc('entry_date')
            ->orderByDesc('id')
            ->limit(5)
            ->get();

        $recentMoodEntries = $user->moodEntries()
            ->orderByDesc('entry_date')
            ->orderByDesc('id')
            ->limit(5)
            ->get();

        return [
            'total_tasks' => $totalTasks,
            'completed_tasks' => $completedTasks,
            'pending_tasks' => $pendingTasks,
            'in_progress_tasks' => $inProgressTasks,
            'active_habits_count' => $activeHabitsCount,
            'today_habit_logs_count' => $todayHabitLogsCount,
            'latest_journal_entry' => $latestJournalEntry,
            'latest_mood_entry' => $latestMoodEntry,
            'average_mood_last_7_days' => $avgMood !== null ? round((float) $avgMood, 2) : null,
            'recent_tasks' => $recentTasks,
            'recent_journal_entries' => $recentJournalEntries,
            'recent_mood_entries' => $recentMoodEntries,
        ];
    }
}
