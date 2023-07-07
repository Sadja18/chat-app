<?php

namespace App\Http\Controllers\Chats;

use App\Http\Controllers\Controller;
use App\Models\Messages;
use App\Models\User;
use App\Models\Conversations;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
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

            $senderId = Auth::user()->name;
            $recipient = User::where('name', $request->input('destination'))->first();

            info('recipient');

            if (!$recipient) {
                return response()->json(['errors' => $validator->errors()], 400);
            }

            $participants = [$senderId, $recipient->name];

            info('participants', $participants);

            sort($participants); // Sort the participant IDs to maintain consistent conversation IDs

            info('sorted');

            // implement logic for following
            // save the sorted $participants array as a string, separated by a delimiter
            $participantsString = implode(":::", $participants);

            // check if the conversation already exists for given participants
            $conversation = Conversations::where('participants', $participantsString);

            info($conversation->get());
            info($conversation->exists());

            if ($conversation->exists()) {
                // conversation exists
                info('conversation exists');
                return response()->json([
                    'message' => 'conversation exists',
                    'data' => [
                        'participants' => $participants,
                        'conversations' => $conversation->get()
                    ]
                ], 200);
            } else {
                // create new conversation
                info('create new conversation');
                $conversation = new Conversations();
                $conversation->participants = $participantsString;
                $conversation->save();

                return response()->json([
                    'message' => 'conversation created',
                    'data' => [
                        'participants' => $participants,
                        'conversations' => $conversation
                    ]
                ], 201);
            }

            // if conversation already exists; retrieve the conversation id
            // else create new conversation, and retrieve the conversation id


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