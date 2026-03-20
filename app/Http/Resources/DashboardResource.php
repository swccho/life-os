<?php

namespace App\Http\Resources;

use App\Models\JournalEntry;
use App\Models\MoodEntry;
use App\Models\Task;
use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;
use Illuminate\Support\Collection;

class DashboardResource extends JsonResource
{
    /**
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        /** @var array<string, mixed> $d */
        $d = $this->resource;

        /** @var Collection<int, Task> $recentTasks */
        $recentTasks = $d['recent_tasks'];
        /** @var Collection<int, JournalEntry> $recentJournal */
        $recentJournal = $d['recent_journal_entries'];
        /** @var Collection<int, MoodEntry> $recentMood */
        $recentMood = $d['recent_mood_entries'];

        return [
            'total_tasks' => $d['total_tasks'],
            'completed_tasks' => $d['completed_tasks'],
            'pending_tasks' => $d['pending_tasks'],
            'in_progress_tasks' => $d['in_progress_tasks'],
            'active_habits_count' => $d['active_habits_count'],
            'today_habit_logs_count' => $d['today_habit_logs_count'],
            'latest_journal_entry' => $d['latest_journal_entry']
                ? (new JournalEntryResource($d['latest_journal_entry']))->resolve()
                : null,
            'latest_mood_entry' => $d['latest_mood_entry']
                ? (new MoodEntryResource($d['latest_mood_entry']))->resolve()
                : null,
            'average_mood_last_7_days' => $d['average_mood_last_7_days'],
            'recent_tasks' => $recentTasks->map(fn (Task $t) => (new TaskResource($t))->resolve())->values()->all(),
            'recent_journal_entries' => $recentJournal->map(fn (JournalEntry $j) => (new JournalEntryResource($j))->resolve())->values()->all(),
            'recent_mood_entries' => $recentMood->map(fn (MoodEntry $m) => (new MoodEntryResource($m))->resolve())->values()->all(),
        ];
    }
}
