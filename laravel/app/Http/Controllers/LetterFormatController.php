<?php

namespace App\Http\Controllers;

use App\Models\LetterFormat;

class LetterFormatController extends Controller
{
    public function index()
    {
        return response()->json([
            'success' => true,
            'data' => LetterFormat::all(),
        ]);
    }
}
