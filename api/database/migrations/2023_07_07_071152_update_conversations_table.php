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
        // make the participants field as text
        // This allows us to store a JSON-encoded string of the participants' usernames as plain text.
        Schema::table('conversations', function (Blueprint $table) {
            $table->text('participants')->nullable()->change();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        //
        Schema::table('conversations', function (Blueprint $table) {
            $table->json('participants')->nullable()->change();
        });
    }
};