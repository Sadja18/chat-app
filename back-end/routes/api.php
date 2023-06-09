<?php

use App\Http\Controllers\OTPController;
use App\Http\Controllers\UserController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;


Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::prefix('/users')->group(function () {
    Route::post('/register', [UserController::class, 'register']);
    Route::post('/login', [UserController::class, 'login'])->name('users.login');
    Route::post('/logout', [UserController::class, 'logout']);
    Route::post('/email/otp', [OTPController::class, 'generateOTP'])->middleware('auth:api')->name('email.otp');
    Route::post('/email/verify', [OTPController::class, 'verifyOTP'])->middleware('auth:api')->name('email.verify');
});

Route::get('/no-auth', function () {
    return json_encode(
        array(
            'message' => 'Unauthorized',
            'error' => 'You are not using an active session',
            'statusCode' => 401
        )
    );
})->name('no-auth');

Route::get('/', function () {
    return json_encode(
        array(
            'message' => 'success',
            'info' => 'Welcome to home'
        )
    );
})->name('/welcome');