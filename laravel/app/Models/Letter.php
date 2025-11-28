<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class Letter extends Model
{
    protected $table = 'letters';
    protected $fillable = [
        'letter_format_id',
        'employee_id',
        'name',
        'status'
    ];

    public function format()
    {
        return $this->belongsTo(LetterFormat::class, 'letter_format_id');
    }

    public function employee()
    {
        return $this->belongsTo(Employee::class, 'employee_id');
    }
}
