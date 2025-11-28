<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Letter;
use App\Models\LetterFormat;
use Illuminate\Http\Request;
use PDF;
use Illuminate\Support\Facades\Storage;

class LetterController extends Controller
{
    public function store(Request $request)
    {
        $request->validate([
            'nama' => 'required|string',
            'jenis_surat' => 'required|integer',
            'tanggal' => 'required|date',
        ]);

        // Ambil format template
        $format = LetterFormat::find($request->jenis_surat);

        if (!$format) {
            return response()->json(['error' => 'Format tidak ditemukan'], 404);
        }

        // Ambil template HTML
        $html = $format->content;

        // Replace placeholders
        $html = str_replace('{{nama}}', $request->nama, $html);
        $html = str_replace('{{tanggal}}', $request->tanggal, $html);

        // Generate PDF
        $pdf = PDF::loadHTML($html);

        // Nama file
        $fileName = 'surat_' . time() . '.pdf';

        // Simpan PDF ke storage/app/public/surat/
        Storage::put("public/surat/$fileName", $pdf->output());

        // Simpan data di database
        $letter = Letter::create([
            'letter_format_id' => $format->id,
            'employee_id' => 1, // nanti diganti user login
            'name' => $request->nama,
            'status' => 1,
            'file_path' => "surat/$fileName"
        ]);

        return response()->json([
            'success' => true,
            'data' => [
                'letter' => $letter,
                'file_url' => asset("storage/surat/$fileName"),
                'rendered_html' => $html,
            ]
        ]);
    }
}
