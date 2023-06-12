<?php

namespace App\Http\Controllers\Profiles;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class VisibilityController extends Controller
{
    //
    public function update(Request $request)
    {
        $user = Auth::user();

        $visibility_setting = $user->visibilitySettings;

        return response()->json($visibility_setting);
    }
}