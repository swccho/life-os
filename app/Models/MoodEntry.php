<?php

namespace App\Models;

use Database\Factories\MoodEntryFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class MoodEntry extends Model
{
    /** @use HasFactory<MoodEntryFactory> */
    use HasFactory;

    protected $fillable = [
        'user_id',
        'mood_score',
        'mood_label',
        'notes',
        'entry_date',
    ];

    protected function casts(): array
    {
        return [
            'mood_score' => 'integer',
            'entry_date' => 'date',
        ];
    }

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }
}
