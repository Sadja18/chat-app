<?php
namespace App\Helpers;

class OTPHelper
{
    public static function generateOTP($length = 7)
    {
        $characters = '0123456789ABDEFGHJKLMNPQRTabdefghjklmnpqrt';
        $otp = '';
        $max = strlen($characters) - 1;
        for ($i = 0; $i < $length; $i++) {
            $otp .= $characters[random_int(0, $max)];
        }
        return $otp;
    }

    public static function validateOTP($otp, $userEnteredOTP)
    {
        return $otp === $userEnteredOTP;
    }

    public static function generateOTPEmailContent($otp)
    {
        $html = "<p>Your OTP is: $otp</p>";
        // Add more HTML content if needed
        return $html;
    }
}