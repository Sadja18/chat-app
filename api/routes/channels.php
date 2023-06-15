<?php

use App\Models\Messages;
use Illuminate\Support\Facades\Broadcast;

/*
|--------------------------------------------------------------------------
| Broadcast Channels
|--------------------------------------------------------------------------
|
| Here you may register all of the event broadcasting channels that your
| application supports. The given channel authorization callbacks are
| used to check if an authenticated user can listen to the channel.
|
*/

Broadcast::channel('App.Models.User.{id}', function ($user, $id) {
    return (int) $user->id === (int) $id;
});


Broadcast::channel('messages.{conversationId}', function ($user, $conversationId) {
    // Implement your own logic here to determine if the user is authorized to listen to the channel
    // return $user->canAccessConversation($conversationId);
    if ($user->canAccessConversation($conversationId)) {
        // Implement your logic to retrieve the messages for the conversation
        $messages = Messages::where('conversation_id', $conversationId)->get();

        return [
            'conversation_id' => $conversationId,
            'messages' => $messages,
        ];
    }
});