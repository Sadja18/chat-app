<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Messages extends Model
{
    use HasFactory;

    protected $table = 'messages';

    protected $fillable = [
        'conversation_id',
        'type',
        'content',
        'message_delivery_status'
    ];

    public function conversation()
    {
        return $this->belongsTo(Conversation::class);
    }
}