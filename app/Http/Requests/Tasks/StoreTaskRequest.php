<?php

namespace App\Http\Requests\Tasks;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

class StoreTaskRequest extends FormRequest
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
            'title' => ['required', 'string', 'max:255'],
            'description' => ['nullable', 'string'],
            'status' => ['nullable', 'string', Rule::in(['pending', 'in_progress', 'completed'])],
            'priority' => ['nullable', 'string', Rule::in(['low', 'medium', 'high'])],
            'due_date' => ['nullable', 'date'],
            'completed_at' => ['nullable', 'date'],
        ];
    }
}
