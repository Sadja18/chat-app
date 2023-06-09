<?php

namespace App\Http\Controllers;

use App\Helpers\OTPHelper;
use App\Models\OTP;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class OTPController extends Controller
{
    /**
     * 
     */
    public function gnerateOTP(Request $request)
    {
        // Generate OTP
        $otp = OTPHelper::generateOTP();

        // Store the OTP in the database
        $user = Auth::user();

        print_r($user);
        OTP::create(
            [
                'user_id' => $user->id,
                'otp' => $otp
            ]
        );

        // Send OTP to the user's email.
        $this->sendVerificationEmail($user->email, $otp);

        return response()->json(['message' => 'OTP generated successfully']);


    }
}