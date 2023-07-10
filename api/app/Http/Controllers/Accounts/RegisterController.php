<?php

namespace App\Http\Controllers\Accounts;

use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Validator;

class RegisterController extends Controller
{
    /**
     * Register api
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function register(Request $request)
    {
        $validator = Validator::make(
            $request->all(),
            [
                'name' => 'required',
                'email' => 'required|email',
                'password' => 'required',
                'confirm_password' => 'required|same:password'
            ]
        );
        if ($validator->fails()) {
            return $this->sendError('Validation Error.', $validator->errors());
        }

        $input = $request->all();

        $isUserNameExists = User::where('name', $input['name'])->get();
        $isEmailExists = User::where('email', $input['email'])->get();

        if ($isUserNameExists && !empty($isUserNameExists)) {
            return response()->json(['message' => 'username is taken'], 500);
        }
        if ($isEmailExists && !empty($isEmailExists)) {
            return response()->json(['message' => 'Account with the provided email already exists'], 500);
        }

        $input['password'] = bcrypt($input['password']);
        $user = User::create($input);
        $success['token'] = $user->createToken('MyApp')->plainTextToken;
        $success['name'] = $user->name;

        return $this->sendResponse($success, 'User register successfully.');
    }


    /**
     * Login api
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function login(Request $request)
    {
        if (Auth::attempt(['email' => $request->email, 'password' => $request->password])) {
            $user = Auth::user();
            $success['token'] = $user->createToken('MyApp')->plainTextToken;
            $success['name'] = $user->name;

            return $this->sendResponse($success, 'User login successfully.');
        } else {
            return $this->sendError('Unauthorised.', ['error' => 'Unauthorised']);
        }
    }

    /**
     * Logout api
     * 
     * @return \Illuminate\Http\JsonResponse
     */
    public function logout(Request $request)
    {
        $user = Auth::user();
        $user->tokens()->delete();

        return response()->json(['message' => 'Logged out successfully']);
    }

    /**
     * Change password
     *
     * @return \Illuminate\Http\JsonResponse
     */
    public function changePassword(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'current_password' => 'required',
                'new_password' => 'required|min:6',
                'confirm_password' => 'required|same:new_password',
            ]);

            if ($validator->fails()) {
                return $this->sendError('Validation Error.', $validator->errors());
            }

            $user = Auth::user();

            if (!Hash::check($request->current_password, $user->password)) {
                return $this->sendError('Invalid password.', ['error' => 'Invalid password']);
            }

            $user->password = bcrypt($request->new_password);
            $user->save();

            return $this->sendResponse([], 'Password changed successfully.');
        } catch (\Exception $e) {
            return $this->sendError('An error occurred.', ['error' => $e->getMessage()]);
        }
    }

    /**
     * Forgot Password
     * 
     * @return \Illuminate\Http\JsonResponse
     */

    public function forgotPassword(Request $request)
    {
        try {
            $validator = Validator::make($request->all(), [
                'email' => 'required|email',
            ]);

            if ($validator->fails()) {
                return $this->sendError('Validation Error.', $validator->errors());
            }

            $user = User::where('email', $request->email)->first();

            if (!$user) {
                return $this->sendError('User not found.', ['error' => 'User not found']);
            }

            // Generate and send OTP (One-Time Password) to the user's email
            // You can implement your preferred method to send the OTP

            // Store the generated OTP and the user's email for verification later
            // $user->otp = generateOTP(); // Implement your OTP generation logic
            // $user->otp_verified = false;
            // $user->save();

            // return $t

            return $this->sendResponse([], 'OTP sent to the registered email address.');
        } catch (\Exception $e) {
            return $this->sendError('An error occurred.', ['error' => $e->getMessage()]);
        }
    }

    public function changePasswordUsingAdminAccess(Request $request)
    {
        $email = $request->email;

        $user = User::where('email', $email)->first();

        info($email);

        $newPassword = $request->newPassword;

        $encryptedHash = bcrypt($newPassword);

        $user->password = $encryptedHash;
        $user->save();

        return $this->sendResponse([], "Password changed for $user->name by admin");
    }
}