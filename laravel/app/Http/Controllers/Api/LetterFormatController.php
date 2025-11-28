<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\LetterFormat;

class LetterFormatController extends Controller
{
    public function index()
    {
        $data = LetterFormat::all();

        return response()->json([
            'success' => true,
            'data' => $data
        ]);
    }
}