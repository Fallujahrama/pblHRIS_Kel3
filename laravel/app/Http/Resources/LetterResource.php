<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class LetterResource extends JsonResource
{
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'letter_format_id' => $this->letter_format_id,
            'user_id' => $this->user_id,
            'name' => $this->name,
            'created_at' => $this->created_at,
            'letter_format' => new LetterFormatResource($this->whenLoaded('letterFormat')),
        ];
    }
}
