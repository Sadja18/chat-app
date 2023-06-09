<?php

namespace App\Helpers;

use Illuminate\Support\Facades\Mail;
use Illuminate\Mail\Mailable;

function sendEmail($to, $subject, $body)
{
    Mail::to($to)->send(new class ($subject, $body) extends Mailable {
        public $subject;
        public $body;

        public function __construct($subject, $body)
        {
            $this->subject = $subject;
            $this->body = $body;
        }

        public function build()
        {
            return $this->subject($this->subject)
                ->html($this->body);
        }
    });
}