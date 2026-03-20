<?php

namespace App\Http\Requests\Habits;

use Illuminate\Foundation\Http\FormRequest;

class StoreHabitLogRequest extends FormRequest
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
            'logged_date' => ['required', 'date'],
            'count' => ['nullable', 'integer', 'min:1'],
            'notes' => ['nullable', 'string'],
        ];
    }
}
