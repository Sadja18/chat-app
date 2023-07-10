<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class AccountActiveMiddleware
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle(Request $request, Closure $next): Response
    {
        info('is user is active middleware');
        info($request->user()->account_state);
        if ($request->user() && $request->user()->account_state !== 1) {
            // User does not have admin role
            return response()->json(['message' => 'Unauthorized'], 403);
        } else {
            return $next($request);

        }
    }
}