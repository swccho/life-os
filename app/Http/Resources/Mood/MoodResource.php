<?php

namespace App\Http\Resources\Mood;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class MoodResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->resource['id'] ?? null,
            'type' => 'mood_log',
            'attributes' => [],
        ];
    }
}
