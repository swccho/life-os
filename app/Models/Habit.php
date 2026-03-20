<?php

namespace App\Models;

use Database\Factories\HabitFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Habit extends Model
{
    /** @use HasFactory<HabitFactory> */
    use HasFactory;

    protected $fillable = [
        'user_id',
        'name',
        'description',
        'frequency_type',
        'target_count',
        'is_active',
    ];

    protected function casts(): array
    {
        return [
            'target_count' => 'integer',
            'is_active' => 'boolean',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function habitLogs(): HasMany
    {
        return $this->hasMany(HabitLog::class);
    }
}
