<?php

namespace App\Http\Controllers\Profiles;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class VisibilityController extends Controller
{
    //
    public function get(Request $request)
    {
        try {
            $user = $request->user();
            $visibilitySetting = $user->visibilitySetting;

            return response()->json([
                'message' => 'success',
                'visibility' => $visibilitySetting,
            ], 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Failed to retrieve visibility settings'], 500);
        }
    }

    public function updateVisibility(Request $request)
    {
        try {
            $user = $request->user();
            $visibilitySetting = $user->visibilitySetting;

            $visibilityData = $request->only([
                'hide_first_name',
                'hide_last_name',
                'hide_country',
                'hide_profile_pic',
                'hide_contact_phone',
                'hide_online_status'
            ]);

            $visibilitySetting->update($visibilityData);

            return response()->json([
                'message' => 'Visibility settings updated successfully'
            ], 200);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Failed to update visibility settings'], 500);
        }
    }
}