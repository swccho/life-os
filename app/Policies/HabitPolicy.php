<?php

namespace App\Policies;

use App\Models\Habit;
use App\Models\User;

class HabitPolicy
{
    public function viewAny(User $user): bool
    {
        return true;
    }

    public function view(User $user, Habit $habit): bool
    {
        return (int) $user->id === (int) $habit->user_id;
    }

    public function create(User $user): bool
    {
        return true;
    }

    public function update(User $user, Habit $habit): bool
    {
        return (int) $user->id === (int) $habit->user_id;
    }

    public function delete(User $user, Habit $habit): bool
    {
        return (int) $user->id === (int) $habit->user_id;
    }
}
