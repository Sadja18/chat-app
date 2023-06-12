<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class VisibilitySettings extends Model
{
    use HasFactory;

    protected $fillable = [
        'hide_first_name',
        'hide_last_name',
        'hide_country',
        'hide_contact_phone',
        'hide_online_status',
        'hide_profile_pic'
    ];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}