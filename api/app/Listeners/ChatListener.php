<?php

namespace App\Listeners;

use App\Events\ChatEvent;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Support\Facades\Broadcast;

class ChatListener implements ShouldQueue
{
    use InteractsWithQueue;
    /**
     * Create the event listener.
     */
    public function __construct()
    {
        //
    }

    /**
     * Handle the event.
     */
    public function handle(ChatEvent $event): void
    {
        dd(config('app.log_level'));
        info('inside the handle of listener of chat event');
        //
        $message = $event->message;
        info($message->sequence_id);

        // Broad cast the event to the conversation channel
        $conversationChannel = 'private-conversation-' . $message->conversation_id;
        info($conversationChannel);
        broadcast($message)->toOthers();
        info('broadcasted');
    }
}