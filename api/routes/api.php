<?php

use App\Http\Controllers\Accounts\RegisterController;
use App\Http\Controllers\OTP\OTPController;
use App\Http\Controllers\Profiles\ProfileController;
use App\Http\Controllers\Profiles\VisibilityController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Routing\Middleware\ThrottleRequests;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
*/

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', function (Request $request) {
        return $request->user();
    });
    // Route::resource('/email', OTPController::class);
});

/*
| ------
| user route
| ------
*/
Route::controller(RegisterController::class)->group(function () {
    Route::post('/register', 'register');
    Route::post('/login', 'login');
});

Route::post('/logout', [RegisterController::class, 'logout'])->middleware('auth:sanctum');

Route::middleware([ThrottleRequests::class . ':5,1'])->group(function () {
    Route::post('/email/otp', [OTPController::class, 'generateOTP'])->middleware('auth:sanctum');
    Route::post('/email/verify', [OTPController::class, 'verifyEmail'])->middleware('auth:sanctum');
});

Route::prefix('profiles')->middleware('auth:sanctum')->group(function () {
    Route::get('/', [ProfileController::class, 'index']);
    Route::post('/', [ProfileController::class, 'store']);
    Route::get('/show', [ProfileController::class, 'show']);
    Route::put('/update', [ProfileController::class, 'update']);
    Route::delete('/delete', [ProfileController::class, 'destroy']);

    Route::get('/online-status', [ProfileController::class, 'getOnlineStatus']);
    Route::put('/online-status', [ProfileController::class, 'updateOnlineStatus']);

    Route::put('/visibility/update', [VisibilityController::class, 'update']);
});