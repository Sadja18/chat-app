<?php

namespace App\Models;

use BeyondCode\LaravelWebSockets\WebSockets\Channels\PrivateChannel;
use BeyondCode\LaravelWebSockets\WebSockets\Channels\PresenceChannel;
use Illuminate\Contracts\Broadcasting\ShouldBroadcastNow;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Messages extends Model
{
    use HasFactory;

    protected $table = 'messages';

    protected $fillable = [
        'conversation_id',
        'sender_id',
        'type',
        'content',
        'message_delivery_status',
        'sequence_id'
    ];

    public function conversation()
    {
        return $this->belongsTo(Conversation::class);
    }

    // public function broadcastOn()
    // {
    //     return new PrivateChannel('private-messages.' . $this->conversation_id);
    // }

    // public function broadcastWith()
    // {
    //     return [
    //         'id' => $this->id,
    //         'content' => $this->content,
    //         'sender' => $this->sender,
    //         // Include any other relevant data
    //     ];
    // }
}