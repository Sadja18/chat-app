<?php

namespace App\Helpers;

class OTPHelper
{

    public static function generateOTP($length = 7)
    {
        $characters = '0123456789ABDEFGHJKLMNPQRTabcdefghijklmnopqrstuvmxyz';

        $otp = '';

        $max = strlen($characters) - 1;
        for ($i = 0; $i < $length; $i++) {
            $otp .= $characters[random_int(0, $max)];
        }

        return $otp;
    }

    public static function validateOTP($otp, $userEnteredOtp)
    {
        return $otp == $userEnteredOtp;
    }

    public static function generateOtpEmailContent($otp)
    {
        $content = "<div><p>Your OTP is: <b>$otp<b></p></div>";

        return $content;
    }
}