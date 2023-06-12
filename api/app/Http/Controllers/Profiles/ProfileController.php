<?php

namespace App\Http\Controllers\Profiles;

use App\Http\Controllers\Controller;
use App\Models\VisibilitySettings;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class ProfileController extends Controller
{
    /**
     * Summary of index
     * @return \Illuminate\Http\JsonResponse
     */
    public function index()
    {
        try {
            $user = Auth::user();
            $profiles = $user->profiles;
            $visibilitySettings = $user->visibilitySettings;

            return response()->json([
                'message' => 'success',
                'infoText' => 'Profile retrieved successfully.',
                'data' => [
                    'username' => $user->name,
                    'profile' => $profiles,
                    'visibility_setting' => $visibilitySettings
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Failed to retrieve profiles'], 500);
        }
    }

    /**
     * Summary of store
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function store(Request $request)
    {
        try {
            $user = Auth::user();

            $existing_profile = $user->existing_profile;
            $visibilitySettings = $user->visibilitySettings;

            // Check if a profile already exists for the user
            if ($existing_profile) {
                return response()->json([
                    'message' => 'Profile already exists',
                    'data' => [
                        'username' => $user->name,
                        'profile' => $existing_profile,
                        'visibility' => $visibilitySettings
                    ]
                ]);
            }

            $profileData = $request->only(['first_name', 'last_name', 'country', 'contact_phone', 'profile_pic']);

            $profile = $user->profiles()->create($profileData);

            // Create a new visibility setting for the user
            $visibilitySettings = $user->visibilitySettings()->create();

            return response()->json([
                'message' => 'Profile created successfully',
                'profile' => $profile,
                'visibility_setting' => $visibilitySettings
            ]);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Failed to create profile'], 500);
        }
    }

    /**
     * Summary of show
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function show(Request $request)
    {
        try {
            $user = $request->user();
            $profile = $user->profile;
            $visibilitySettings = $user->visibilitySettings;

            return response()->json([
                'message' => 'success',
                'infoText' => 'Profile retrieved successfully.',
                'data' => [
                    'username' => $user->name,
                    'profile' => $profile,
                    'visibilitySettings' => $visibilitySettings
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Failed to retrieve profile'], 500);
        }
    }

    /**
     * Summary of update
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function update(Request $request)
    {
        try {
            $user = $request->user();
            $profile = $user->profile;

            // Check if a profile exists for the user
            if (!$profile) {
                return response()->json([
                    'message' => 'Profile does not exist',
                ], 404);
            }

            $profileData = $request->only(['first_name', 'last_name', 'country', 'contact_phone', 'profile_pic']);
            $profile->update($profileData);

            return response()->json([
                'message' => 'Profile updated successfully',
                'data' => [
                    'username' => $user->name,
                    'profile' => $profile
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to update profile',
            ], 500);
        }
    }

    /**
     * Summary of destroy
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function destroy(Request $request)
    {
        try {
            $user = $request->user();
            $profile = $user->profile;
            $visibilitySettings = $user->visibilitySettings;

            // Check if a profile exists for the user
            if (!$profile) {
                return response()->json([
                    'message' => 'Profile does not exist',
                ], 404);
            }

            $profile->delete();

            if ($visibilitySettings) {
                $visibilitySettings->delete();
            }

            return response()->json([
                'message' => 'Profile deleted successfully',
                'data' => [
                    'username' => $user->name,
                ]
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to delete profile',
            ], 500);
        }
    }

    /**
     * Summary of getOnlineStatus
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function getOnlineStatus(Request $request)
    {
        try {
            $user = $request->user();
            $onlineStatus = $user->profile ? $user->profile->online_status : false;

            return response()->json([
                'message' => 'Online status retrieved successfully',
                'data' => $onlineStatus,
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to retrieve online status',
            ], 500);
        }
    }

    /**
     * Summary of updateOnlineStatus
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function updateOnlineStatus(Request $request)
    {
        try {
            $user = $request->user();
            $profile = $user->profile;

            // Check if a profile exists for the user
            if (!$profile) {
                return response()->json([
                    'message' => 'Profile does not exist',
                ], 404);
            }

            $onlineStatus = $request->input('online_status');
            $profile->online_status = $onlineStatus;
            $profile->save();

            return response()->json([
                'message' => 'Online status updated successfully',
                'data' => [
                    'username' => $user->name,
                    'online_status' => $profile->online_status
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to update online status',
            ], 500);
        }
    }
}