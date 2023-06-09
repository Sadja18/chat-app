<?php

use App\Http\Controllers\Accounts\RegisterController;
use App\Http\Controllers\OTP\OTPController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Routing\Middleware\ThrottleRequests;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
    // Route::resource('/email', OTPController::class);
});


Route::controller(RegisterController::class)->group(function () {
    Route::post('/register', 'register');
    Route::post('/login', 'login');
});

Route::post('/logout', [RegisterController::class, 'logout'])->middleware('auth:sanctum');

Route::middleware([ThrottleRequests::class . ':5,1'])->group(function () {
    Route::post('/email/otp', [OTPController::class, 'generateOTP'])->middleware('auth:sanctum');
    Route::post('/email/verify', [OTPController::class, 'verifyEmail'])->middleware('auth:sanctum');
});