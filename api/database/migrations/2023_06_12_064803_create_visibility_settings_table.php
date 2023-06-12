<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('visibility_settings', function (Blueprint $table) {
            $table->id();
            $table->unsignedBigInteger('user_id');
            $table->boolean('hide_first_name')->default(false);
            $table->boolean('hide_last_name')->default(false);
            $table->boolean('hide_country')->default(false);
            $table->boolean('hide_profile_pic')->default(false);
            $table->boolean('hide_contact_phone')->default(false);
            $table->boolean('hide_online_status')->default(false);
            $table->timestamps();

            $table->foreign('user_id')->references('id')->on('users')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('visibility_settings');
    }
};