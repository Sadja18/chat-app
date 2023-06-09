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
    public function generateOTP(Request $request)
    {
        $otp = OTPHelper::generateOTP();

        Log::info("$otp geneated controller");

        $user = Auth::user();

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
    }

    public function verifyEmail(Request $request)
    {
        $otp = $request->input('otp');

        $validFormat = preg_match('/^[a-zA-Z0-9]{7}$/', $otp);

        if (!$validFormat) {
            return response()->json(['message' => 'Invalid OTP format'], 422);
        }

        // Retrieve the stored OTP from the database
        $user = Auth::user();
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
    }
}