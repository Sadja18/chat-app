<?php

namespace App\Http\Controllers\OTP;

use App\Helpers\EmailHelper;
use App\Helpers\OTPHelper;
use App\Http\Controllers\Controller;
use App\Models\OTP;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use Validator;

class OTPController extends Controller
{

    public function checkIfEmailIsVerified(Request $request)
    {
        try {
            $user = $request->user();

            if ($user) {

                return response()->json(
                    [
                        'message' => 'successfully fetched',
                        'data' => [
                            'email_verification-status' => $user->email_verified_at ? $user->email_verified_at : false,
                            // gettype($user)
                        ]
                    ],
                    200
                );
            } else {
                return response()->json(
                    [
                        'message' => 'Not found',
                        'error' => "user not found"
                    ],
                    404
                );
            }
        } catch (\Exception $e) {
            return response()->json(
                ['message' => 'error occurred in checking if email is verified', 'error' => $e->getMessage()],
                500
            );
        }
    }


    public function generateOTP(Request $request)
    {

        try {
            $user = $request->user();
            if ($user) {
                $otp = OTPHelper::generateOTP();

                Log::info("$otp geneated controller");

                $user = $request->user();

                Log::info("generate otp controller user fetched");

                OTP::create(
                    [
                        'user_id' => $user->id,
                        'otp' => $otp,
                    ]
                );

                Log::info("generate otp controller otp row created");

                $email = $user->email;

                Log::info('The email is being sent');
                Log::info("$email :: $otp");

                $content = "<div><p>OTP for verification is: <b>$otp</b></p></div>";
                $subject = "Verification OTP";

                // $mailerObj = MailHelper();

                $sentAttempt = EmailHelper::sendEmail($email, $subject, $content);

                $status = array_key_exists('message', $sentAttempt) && $sentAttempt['message'] == 'success' ? 200 : 500;

                return response()->json($sentAttempt, $status);
            } else {
                return response()->json(
                    [
                        'message' => 'Not found',
                        'error' => "user not found"
                    ],
                    404
                );
            }
        } catch (\Exception $e) {
            return response()->json(
                ['message' => 'error occurred in checking if email is verified', 'error' => $e->getMessage()],
                500
            );
        }
    }

    public function verifyEmail(Request $request)
    {
        try {
            $user = $request->user();
            if ($user) {
                $otp = $request->input('otp');

                $validFormat = preg_match('/^[a-zA-Z0-9]{7}$/', $otp);

                if (!$validFormat) {
                    return response()->json(['message' => 'Invalid OTP format'], 422);
                }

                // Retrieve the stored OTP from the database
                $user = $request->user();

                // $senderId = $user->id;
                $storedOTP = OTP::where('user_id', $user->id)->orderBy('created_at', 'desc')->first();

                if ($storedOTP && OTPHelper::validateOTP($storedOTP->otp, $otp)) {
                    // Mark the user's email as verified
                    DB::table('users')->where('id', $user->id)->update(['email_verified_at' => now()]);

                    // Delete the verified OTP from the database
                    $storedOTP->delete();

                    return response()->json(['message' => 'Email verified successfully']);
                } else {
                    return response()->json(['message' => 'Invalid OTP'], 422);
                }
            } else {
                return response()->json(
                    [
                        'message' => 'Not found',
                        'error' => "user not found"
                    ],
                    404
                );
            }
        } catch (\Exception $e) {
            return response()->json(
                ['message' => 'error occurred in checking if email is verified', 'error' => $e->getMessage()],
                500
            );
        }
    }
}