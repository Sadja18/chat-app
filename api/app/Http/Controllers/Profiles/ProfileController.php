<?php

namespace App\Http\Controllers\Profiles;

use App\Http\Controllers\Controller;
use App\Models\Profile;
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
            // Check if the user already has a profile
            $existingProfile = $user->profile;
            // Check if the user already has a profile
            $visibilitySettings = $user->profileVisibility;


            if ($existingProfile) {
                // $existingProfile = Profile::where('user_id', $user->id)->first();

                if ($visibilitySettings) {
                    // $visibilitySettings = $user->profileVisibility;
                    return response()->json([
                        'message' => 'success',
                        'infoText' => 'Profile retrieved successfully.',
                        'data' => [
                            'username' => $user->name,
                            'profile' => $existingProfile,
                            'visibility_setting' => $visibilitySettings
                        ]
                    ]);
                } else {
                    return response()->json([
                        'message' => 'success',
                        'infoText' => 'Profile retrieved successfully.',
                        'data' => [
                            'username' => $user->name,
                            'profile' => $existingProfile,
                            'visibility_setting' => $visibilitySettings
                        ]
                    ]);
                }

            } else {
                return response()->json([
                    'message' => 'success',
                    'infoText' => 'Profile retrieved successfully.',
                    'data' => [
                        'username' => $user->name,
                        'profile' => $existingProfile,
                        'visibility_setting' => $visibilitySettings
                    ]
                ]);
            }
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
            info("Auth user checking");
            $user = Auth::user();

            // info("$user ', $user->i");
            $user_id = $user->id;

            // Check if the user already has a profile
            $profileExists = Profile::where('user_id', $user_id)->exists();
            // Check if the user already has a profile
            $visibilityExists = VisibilitySettings::where('user_id', $user_id)->exists();

            // Check if a profile already exists for the user
            if ($profileExists && $visibilityExists) {
                // both profile and visibility settings exists
                $existing_profile = Profile::where('user_id', $user_id)->first();
                $visibilitySettings = VisibilitySettings::where('user_id', $user_id)->first();
                return response()->json([
                    'message' => 'Profile already exists',
                    'data' => [
                        'username' => $user->name,
                        'profile' => $existing_profile,
                        'visibility' => $visibilitySettings
                    ]
                ]);
            } else if (!$profileExists && !$visibilityExists) {
                // neither profile nor visibility settings exists

                // create profile
                $profileData = $request->only([
                    "first_name",
                    "last_name",
                    "contact_phone",
                    "country",
                    "profile_pic",
                    "online_status"
                ]);
                info('reqyest');

                info($profileData);

                if (array_key_exists('online_status', $profileData)) {
                    $profileData['online_status'] = $profileData['online_status'] ? true : false;
                } else {
                    $profileData['online_status'] = 0;
                }

                if (array_key_exists('profile_pic', $profileData)) {
                    $profileData['profile_pic'] = empty($profileData['profile_pic']) ? null : $profileData['profile_pic'];
                } else {
                    $profileData['profile_pic'] = 0;
                }

                $profileData['user_id'] = $user_id;

                info("profile_data");

                $profile = Profile::create($profileData);

                info("profile $profile");

                $profile->save();

                info('profile saved');

                $visibilityData = [
                    'user_id' => $user_id,
                    'hide_first_name' => false,
                    'hide_last_name' => false,
                    'hide_country' => false,
                    'hide_profile_pic' => false,
                    'hide_contact_phone' => false,
                    'hide_online_status' => false
                ];

                info('$visibilityData');

                // create visibility settings
                $visibilitySettings = VisibilitySettings::create($visibilityData);

                info($visibilitySettings);

                $visibilitySettings->save();

                return response()->json([
                    'message' => 'Profile created successfully',
                    'profile' => $profileExists,
                    'visibility_setting' => $visibilityExists
                ]);

            } else if ($profileExists && !$visibilityExists) {
                // profile exists but not visitibility settings

                // get profile
                $profile = Profile::where('user_id', $user_id)->first();

                info('profile exists, creating visibility');
                info($profile);

                $userId = Auth::id(); // Retrieve the authenticated user's ID
                $visibilityData = [
                    'user_id' => $userId,
                    'hide_first_name' => false,
                    'hide_last_name' => false,
                    'hide_country' => false,
                    'hide_profile_pic' => false,
                    'hide_contact_phone' => false,
                    'hide_online_status' => false
                ];

                info('$visibilityData');

                // create visibility settings
                $visibilitySettings = VisibilitySettings::create($visibilityData);

                info($visibilitySettings);

                $visibilitySettings->save();

                return response()->json([
                    'message' => 'Profile created successfully',
                    'profile' => $profile,
                    'visibility_setting' => $visibilitySettings
                ]);

            } else {
                // profile does not exists but visibility settings exist

                // create profile
                $profileData = $request->only([
                    "first_name",
                    "last_name",
                    "contact_phone",
                    "country",
                    "profile_pic",
                    "online_status"
                ]);
                info('reqyest');

                if (array_key_exists('online_status', $profileData)) {
                    $profileData['online_status'] = $profileData['online_status'] ? true : false;
                } else {
                    $profileData['online_status'] = 0;
                }

                if (array_key_exists('profile_pic', $profileData)) {
                    $profileData['profile_pic'] = empty($profileData['profile_pic']) ? null : $profileData['profile_pic'];
                } else {
                    $profileData['profile_pic'] = 0;
                }

                $profileData['user_id'] = $user_id;

                info("profile_data");

                $profile = Profile::create($profileData);

                info("profile $profile");

                $profile->save();

                info('profile saved');

                $profileData['user_id'] = $user_id;

                info("profile_data");

                $profile = Profile::create($profileData);

                info("profile $profile");

                // get visibility settings:

                $visibilitySettings = VisibilitySettings::where('user_id', $user_id)->first();

                return response()->json([
                    'message' => 'Profile created successfully',
                    'profile' => $profile,
                    'visibility_setting' => $visibilitySettings
                ]);

            }

        } catch (\Exception $e) {
            info($e->getTraceAsString());
            return response()->json([
                'message' => 'Failed to create profile',
                'error' => $e->getMessage(),
            ], 500);
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
            $user = Auth::user();
            $profile = $user->profile;
            $visibilitySettings = $user->profileVisibility;

            if (!$profile) {
                return response()->json([
                    'message' => 'Profile does not exist',
                ], 404);
            }

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
            $user = Auth::user();
            $profile = Profile::where('user_id', $user->id)->first();

            // Check if a profile exists for the user
            if (!$profile) {
                return response()->json([
                    'message' => 'Profile does not exist',
                ], 404);
            }

            $field = $request->input('field');
            $value = $request->input('value');

            // Update the specified field
            $this->updateProfileField($profile, $field, $value);

            return response()->json([
                'message' => 'Profile updated successfully',
                'data' => [
                    'username' => $user->name,
                    'profile' => $profile->refresh(),
                ],
            ]);
        } catch (\Exception $e) {
            return response()->json([
                'message' => 'Failed to update profile',
            ], 500);
        }
    }

    private function updateProfileField(Profile $profile, $field, $value)
    {
        switch ($field) {
            case 'first_name':
                $profile->first_name = $value;
                break;
            case 'last_name':
                $profile->last_name = $value;
                break;
            case 'country':
                $profile->country = $value;
                break;
            case 'contact_phone':
                $profile->contact_phone = $value;
                break;
            case 'profile_pic':
                $profile->profile_pic = $value;
                break;
            case 'online_status':
                $profile->online_status = $value;
                break;
            default:
                // Handle any other fields or validation
                return response()->json([
                    'message' => 'Invalid field name',
                ], 400);
        }

        $profile->save();
    }

    /**
     * Summary of destroy
     * @param \Illuminate\Http\Request $request
     * @return \Illuminate\Http\JsonResponse
     */
    public function destroy(Request $request)
    {
        try {
            $user = Auth::user();
            $profile = Profile::where('user_id', $user->id)->first();
            $visibilitySettings = VisibilitySettings::where('user_id', $user->id)->first();

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
            $user = Auth::user();
            // $onlineStatus = $user->profile ? $user->profile->online_status : false;
            $profile = $user->profile;

            if (!$profile) {
                return response()->json(
                    [
                        'message' => 'Profile does not exists'
                    ],
                    404
                );
            }

            $onlineStatus = $profile->online_status;

            return response()->json([
                'message' => 'Online status retrieved successfully',
                'data' => [
                    'is_online' => $onlineStatus == 0 ? false : true,
                ],
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
            $user = Auth::user();
            $profile = Profile::where('user_id', $user->id)->first();

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