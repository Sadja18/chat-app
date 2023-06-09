<?php

namespace App\Helpers;

use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Log;
use PHPMailer\PHPMailer\PHPMailer;
use PHPMailer\PHPMailer\Exception;
use PHPMailer\PHPMailer\SMTP;

class EmailHelper extends Controller
{
    public static function sendEmail($receiver, $subject, $content)
    {
        require base_path("vendor/autoload.php");
        $mail = new PHPMailer(true);

        try {
            $mail->SMTPDebug = 0;
            $mail->isSMTP();
            $mail->Host = env('MAIL_HOST', 'smtp.relay-sendinblue.com');
            $mail->Username = env('MAIL_USERNAME', 'namanmishraec1045@gmail.com');
            $mail->SMTPAuth = true;
            $mail->Password = env('MAIL_PASSWORD', 'vqvgzrdczlhknoim');
            $mail->SMTPSecure = env('MAIL_ENCRYPTION', '');
            $mail->Port = env('MAIL_PORT', '587');

            Log::info("$mail->Host $mail->Username $mail->SMTPAuth $mail->Password $mail->SMTPSecure $mail->Port");

            $mail->setFrom('no-reply@baatcheet.com', 'no-reply');
            $mail->addAddress($receiver);
            // $mail->addCC(emailCc);
            // $mail->addBCC(emailBcc);

            $mail->isHTML(true);

            $mail->Subject = $subject;
            $mail->Body = $content;

            if (!$mail->send()) {

                $error = $mail->ErrorInfo;

                return array(
                    'message' => 'failed',
                    'info' => 'mail cannot be sent',
                    'error' => json_encode($error)
                );
            } else {
                return array(
                    'message' => 'success',
                    'info' => 'mail sent successfully'
                );
            }

        } catch (Exception $e) {
            return array(
                "message" => 'failed',
                "info" => "could not sent the email to $receiver",
                "error" => $e
            );
        }
    }
}