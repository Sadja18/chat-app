<?php

namespace App\Http\Controllers\Accounts;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\UserRole;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Hash;
use Validator;

class RegisterController extends Controller
{
    /**
     * The function registers a user by validating the input, checking if the username and email
     * already exist, encrypting the password, assigning a default role and account state, creating the
     * user, and returning a success response with a token and name.
     * 
     * @param Request request The  parameter is an instance of the Request class, which
     * represents an HTTP request. It contains all the data and information about the request, such as
     * the request method, headers, and input data.
     * 
     * @return \Illuminate\Http\JsonResponse response with a success message and the user's name and token if the registration is
     * successful. If there are validation errors, it will return an error message with the validation
     * errors. If the username or email already exists, it will return an error message indicating
     * that.
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
            // return $this->sendError('Validation Error.', $validator->errors());
            return response()->json(
                [
                    "message" => 'Validation error',
                    "error" => $validator->errors()
                ],
                403
            );
        }

        $input = $request->all();

        $isUserNameExists = User::where('name', $input['name'])->exists();
        $isEmailExists = User::where('email', $input['email'])->exists();

        if ($isUserNameExists) {
            info($isUserNameExists);
            return response()->json(['message' => 'username is taken'], 500);
        }
        if ($isEmailExists) {
            info($isEmailExists);
            return response()->json(['message' => 'Account with the provided email already exists'], 500);
        }

        $input['password'] = bcrypt($input['password']);

        // set the user as normal user by default

        // role id for normal user 
        $userRole = UserRole::where('name', 'User')->first();
        $user_role_id = $userRole->value('id');

        // update the input array to include the role id
        $input['role_id'] = $user_role_id;

        // set user active set as 1
        // to mark the user account as active
        $input['account_state'] = 1;

        $user = User::create($input);
        $success['token'] = $user->createToken('MyApp')->plainTextToken;
        $success['name'] = $user->name;

        return $this->sendResponse($success, 'User register successfully.');
    }

    /**
     * The login function attempts to authenticate a user with the provided email and password, and if
     * successful, generates a token and returns a success response with the token and user's name.
     * 
     * @param Request request The  parameter is an instance of the Request class, which
     * represents an HTTP request. It contains information about the request, such as the request
     * method, URL, headers, and input data.
     * 
     * @return \Illuminate\Http\JsonResponse the authentication attempt is successful, the function will return a response with
     * the user's token and name, along with a success message. If the authentication attempt fails,
     * the function will return an error response with the message 'Unauthorised'.
     */
    public function login(Request $request)
    {
        if (Auth::attempt(['email' => $request->email, 'password' => $request->password])) {
            $user = $request->user();
            $success['token'] = $user->createToken('MyApp')->plainTextToken;
            $success['name'] = $user->name;

            return $this->sendResponse($success, 'User login successfully.');
        } else {
            return $this->sendError('Unauthorised.', ['error' => 'Unauthorised']);
        }
    }

    /**
     * The above function logs out the user by deleting all their tokens and returns a JSON response
     * indicating successful logout.
     * 
     * @param Request request The  parameter is an instance of the Request class, which
     * represents an HTTP request. It contains information about the request such as the request
     * method, headers, and input data. In this case, it is used to retrieve the authenticated user
     * making the request.
     * 
     * @return \Illuminate\Http\JsonResponse JSON response with a message indicating that the user has been logged out
     * successfully.
     */
    public function logout(Request $request)
    {
        $user = $request->user();
        $user->tokens()->delete();

        return response()->json(['message' => 'Logged out successfully']);
    }

    /**
     * The function is used to change the password of a user in a PHP application, after validating the
     * input and checking the current password.
     * 
     * @param Request request The  parameter is an instance of the Request class, which
     * represents an HTTP request. It contains all the data and information about the request, such as
     * the request method, headers, and input data.
     * 
     * @return \Illuminate\Http\JsonResponse response in the form of a JSON object. If the validation fails, it returns an error
     * message along with the validation errors. If the current password is invalid, it returns an
     * error message indicating that the password is invalid. If the password change is successful, it
     * returns an empty array along with a success message. If an exception occurs during the process,
     * it returns an error message
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

            $user = $request->user();

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
     * The `forgotPassword` function in PHP is used to generate and send an OTP (One-Time Password) to
     * a user's email address for password reset.
     * 
     * @param Request request The  parameter is an instance of the Request class, which
     * contains the data and information sent by the client in the HTTP request. In this case, it is
     * used to retrieve the email entered by the user.
     * 
     * @return \Illuminate\Http\JsonResponse response with an empty array and a message "OTP sent to the registered email address."
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

            return response()->json(
                [
                    'message' => 'OTP sent to the registered email address.'
                ],
                200
            );
        } catch (\Exception $e) {
            return $this->sendError('An error occurred.', ['error' => $e->getMessage()]);
        }
    }

    /**
     * The function changes the password for a user with admin access and sends a response indicating
     * the success of the operation.
     * 
     * @param Request request The  parameter is an instance of the Request class, which is used
     * to retrieve data from the HTTP request. In this case, it is used to retrieve the email and
     * newPassword values from the request.
     * 
     * @return \Illuminate\Http\JsonResponse response with an empty array and a message indicating that the password has been
     * changed for the specified user by an admin.
     */
    public function changePasswordUsingAdminAccess(Request $request)
    {
        $email = $request->email;

        $user = User::where('email', $email)->first();

        info($email);

        $newPassword = $request->newPassword;

        $encryptedHash = bcrypt($newPassword);

        $user->password = $encryptedHash;
        $user->save();

        return response()->json([
            "message" => "Password changed for $user->name by admin",
        ], 200);

        // return $this->sendResponse([], );
    }
}