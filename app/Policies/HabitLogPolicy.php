<?php

namespace App\Policies;

use App\Models\HabitLog;
use App\Models\User;

class HabitLogPolicy
{
    public function view(User $user, HabitLog $habitLog): bool
    {
        return (int) $user->id === (int) $habitLog->user_id;
    }

    public function delete(User $user, HabitLog $habitLog): bool
    {
        return (int) $user->id === (int) $habitLog->user_id;
    }
}
