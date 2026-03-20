<?php

namespace App\Http\Requests\Mood;

use Illuminate\Foundation\Http\FormRequest;

class StoreMoodEntryRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /**
     * @return array<string, mixed>
     */
    public function rules(): array
    {
        return [
            'mood_score' => ['required', 'integer', 'min:1', 'max:5'],
            'mood_label' => ['nullable', 'string', 'max:100'],
            'notes' => ['nullable', 'string'],
            'entry_date' => ['required', 'date'],
        ];
    }
}
