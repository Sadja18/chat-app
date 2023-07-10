<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

// use 

class User extends Authenticatable
{
    use HasApiTokens, HasFactory, Notifiable;

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'account_state', // to track if user is activated or deactivated or pending verification
        'role_id', // field to check permissions
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
    ];

    public function profile()
    {
        return $this->hasOne(Profile::class, 'user_id');
    }

    public function profileVisibility()
    {
        return $this->hasOne(VisibilitySettings::class, 'user_id');
    }

    public function sentConversations()
    {
        return $this->hasMany(Conversation::class, 'sender_user_id');
    }

    public function receivedConversations()
    {
        return $this->hasMany(Conversation::class, 'receiver_user_id');
    }

    public function canAccessConversation($conversationId)
    {
        // Retrieve the conversation from the database
        $conversation = Conversations::find($conversationId);

        if ($conversation) {
            // Check if the user is authenticated and matches any of the participants in the conversation
            if ($conversation->participants->contains('id', $this->id)) {
                return true;
            }
        }

        return false;
    }

    public function isActive()
    {
        return $this->account_state;
    }

    public function role()
    {
        return $this->belongsTo(UserRole::class, 'role_id');
    }
}