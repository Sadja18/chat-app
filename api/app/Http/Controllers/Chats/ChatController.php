<?php

namespace App\Http\Controllers\Chats;

use App\Events\ChatEvent;
use App\Http\Controllers\Controller;
use App\Models\Messages;
use App\Models\User;
use App\Models\Conversations;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;
use Illuminate\Validation\ValidationException;
use Ramsey\Uuid\Type\Integer;

class ChatController extends Controller
{

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

            $recipientId = $recipient->id;

            $participants = [$senderId, $recipientId];

            info('participants', $participants);

            sort($participants); // Sort the participant IDs to maintain consistent conversation IDs

            info('sorted');

            // implement logic for following
            // save the sorted $participants array as a string, separated by a delimiter
            $participantsString = implode(":::", $participants);

            // check if the conversation already exists for given participants
            $conversation = Conversations::where('participants', $participantsString);

            $output = null;

            // info($conversation->get());
            info($conversation->exists());
            // info(gettype($conversation->get()[0]->id));

            if ($conversation->exists()) {
                // conversation exists
                info('conversation exists');
                $conversation_id = $conversation->first()->id;

                // info($conversation_id);
                $message_content = $request->input('content');
                $message_type = $request->input('type');
                // info($message_content);

                // check if messages exists
                $messages = $conversation->first()->messages();
                info($messages->count());

                $sequence_id = $messages->count() + 1;

                $message = new Messages([
                    'conversation_id' => $conversation_id,
                    'sequence_id' => $sequence_id,
                    'sender_id' => $senderId,
                    'type' => $message_type,
                    'content' => $message_content,
                    'message_delivery_status' => 'pending' // Assuming you have a default status
                ]);

                info('message save');

                $message->save();

                // return response()->json(, 201);
                $output = [
                    'message' => 'Message sent successfully',
                    'data' => $message
                ];
            } else {
                // create new conversation
                info('create new conversation');
                $conversation = new Conversations();
                $conversation->participants = $participantsString;
                $conversation->save();

                $conversation_id = $conversation->id;

                $message_content = $request->input('content');
                $message_type = $request->input('type');
                // info($message_content);

                $messages = $conversation->first()->messages();
                info($messages->count());

                $sequence_id = $messages->count() + 1;

                $message = new Messages([
                    'conversation_id' => $conversation_id,
                    'sequence_id' => $sequence_id,
                    'sender_id' => $senderId,
                    'type' => $message_type,
                    'content' => $message_content,
                    'message_delivery_status' => 'pending' // Assuming you have a default status
                ]);

                info('message save');

                $message->save();
                $output = [
                    'message' => 'Message sent successfully',
                    'data' => $message
                ];


            }
            info('triggering web sokcet event to send message');

            event(new ChatEvent($message));

            info('sending api response to sender');

            return response()->json($output, 201);



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