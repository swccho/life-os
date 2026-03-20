<?php

namespace App\Policies;

use App\Models\MoodEntry;
use App\Models\User;

class MoodEntryPolicy
{
    public function viewAny(User $user): bool
    {
        return true;
    }

    public function view(User $user, MoodEntry $moodEntry): bool
    {
        return (int) $user->id === (int) $moodEntry->user_id;
    }

    public function create(User $user): bool
    {
        return true;
    }

    public function update(User $user, MoodEntry $moodEntry): bool
    {
        return (int) $user->id === (int) $moodEntry->user_id;
    }

    public function delete(User $user, MoodEntry $moodEntry): bool
    {
        return (int) $user->id === (int) $moodEntry->user_id;
    }
}
