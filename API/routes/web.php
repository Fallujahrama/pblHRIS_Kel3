<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\LetterController;

Route::get('/', function () {
    return view('welcome');
});


Route::get('/letters/{id}/pdf', [LetterController::class, 'generatePdf']);
