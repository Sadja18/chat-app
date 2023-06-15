<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Conversations extends Model
{
    use HasFactory;

    protected $table = 'conversations';

    protected $fillable = [
        'participants'
    ];

    public function messages()
    {
        return $this->hasMany(Message::class);
    }

}