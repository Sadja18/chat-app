<?php

namespace App\Http\Controllers\Chats;

use App\Http\Controllers\Controller;
use App\Models\Messages;
use App\Models\User;
use App\Models\Conversations;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\ValidationException;

class ChatController extends Controller
{
    //
    public function sendMessage(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'type' => 'required|in:text,image',
                'content' => 'required|string',
                'destination' => 'required|string'
            ]);

            info("validator");

            if ($validator->fails()) {
                return response()->json(['errors' => $validator->errors()], 400);
            }

            $senderId = Auth::user()->id;
            $recipient = User::where('name', $request->input('destination'))->first();

            info('recipient');

            if (!$recipient) {
                return response()->json(['errors' => $validator->errors()], 400);
            }

            $participants = [$senderId, $recipient->id];

            // info('participants' . " $participants[0]");

            sort($participants); // Sort the participant IDs to maintain consistent conversation IDs

            info('sorted');

            $conversation = Conversations::where('participants', $participants)->first();

            info('conversation');

            if (!$conversation) {
                // Create a new conversation if none exists between the sender and recipient
                info(gettype($participants));
                $conversation = Conversations::create([
                    'participants' => $participants
                ]);
            }
            info('message');

            $message = new Messages([
                'conversation_id' => $conversation->id,
                'sequence_id' => $conversation->messages()->count() + 1,
                'sender_id' => $senderId,
                'type' => $request->input('type'),
                'content' => $request->input('content'),
                'message_delivery_status' => 'pending' // Assuming you have a default status
            ]);

            info('message save');

            $message->save();

            return response()->json(['message' => 'Message sent successfully'], 200);
        } catch (ValidationException $e) {
            return response()->json(['error' => $e->errors()], 400);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }


    public function getMessage(Request $request)
    {
        try {
            //code...
            $user = Auth::user();

            $validator = Validator::make($request->all(), [
                'conversation_id' => 'required|int',
                'limit' => 'required|int',
                'offset' => 'required|int'
            ]);

            if ($validator->fails()) {
                return response()->json(['error' => $validator->errors()], 400);
            }

            $conversationId = $request->input('conversation_id');
            $limit = $request->input('limit');
            $offset = $request->input('offset');

            $messages = Messages::where('conversation_id', $conversationId)
                ->orderBy('created_at', 'desc')
                ->limit($limit)
                ->offset($offset)
                ->get();

            if ($messages->isEmpty()) {
                return response()->json(['message' => 'No messages found for the conversation.'], 404);
            }

            return response()->json(['messages' => $messages], 200);

        } catch (ValidationException $e) {
            return response()->json(['error' => $e->errors()], 400);
        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }
}