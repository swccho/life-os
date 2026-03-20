<?php

namespace App\Http\Resources\Habits;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class HabitResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->resource['id'] ?? null,
            'type' => 'habit',
            'attributes' => [],
        ];
    }
}
