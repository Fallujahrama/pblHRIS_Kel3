<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\LetterFormatController;
use App\Http\Controllers\Api\LetterController;

// Ambil list template
Route::get('/letter-formats', [LetterFormatController::class, 'index']);

// Create surat dari Flutter
Route::post('/letters', [LetterController::class, 'store']);
