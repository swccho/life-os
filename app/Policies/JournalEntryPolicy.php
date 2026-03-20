<?php

namespace App\Policies;

use App\Models\JournalEntry;
use App\Models\User;

class JournalEntryPolicy
{
    public function viewAny(User $user): bool
    {
        return true;
    }

    public function view(User $user, JournalEntry $journalEntry): bool
    {
        return (int) $user->id === (int) $journalEntry->user_id;
    }

    public function create(User $user): bool
    {
        return true;
    }

    public function update(User $user, JournalEntry $journalEntry): bool
    {
        return (int) $user->id === (int) $journalEntry->user_id;
    }

    public function delete(User $user, JournalEntry $journalEntry): bool
    {
        return (int) $user->id === (int) $journalEntry->user_id;
    }
}
