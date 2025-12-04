<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Letter;
use App\Models\Employee;
use Illuminate\Http\Request;

class LetterController extends Controller
{
    // GET all letters
    public function index()
    {
        try {
            $letters = Letter::with(['letterFormat', 'employee.user', 'employee.department', 'employee.position'])
                ->orderBy('created_at', 'desc')
                ->get();

            return response()->json([
                'success' => true,
                'data' => $letters
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    // POST create letter
    public function store(Request $request)
    {
        try {
            $request->validate([
                'letter_format_id' => 'required|exists:letter_formats,id',
                'name' => 'required|string|max:100',
                'jabatan' => 'required|string|max:100',
                'departemen' => 'required|string|max:100',
                'tanggal' => 'required|date',
            ]);

            // Cari employee berdasarkan nama
            $employee = Employee::whereRaw("CONCAT(first_name, ' ', last_name) = ?", [$request->name])
                ->first();

            $letter = Letter::create([
                'letter_format_id' => $request->letter_format_id,
                'employee_id' => $employee ? $employee->id : null, // Simpan employee_id
                'name' => $request->name,
                'jabatan' => $request->jabatan,
                'departemen' => $request->departemen,
                'tanggal' => $request->tanggal,
                'status' => 'pending', // default
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Surat berhasil diajukan',
                'data' => $letter->load('letterFormat')
            ], 201);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    // GET single letter
    public function show($id)
    {
        try {
            $letter = Letter::with(['letterFormat', 'employee'])->findOrFail($id);

            return response()->json([
                'success' => true,
                'data' => $letter
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Letter tidak ditemukan'
            ], 404);
        }
    }

    // PUT update status (untuk HRD approve/reject)
    public function updateStatus(Request $request, $id)
    {
        try {
            $letter = Letter::findOrFail($id);

            $request->validate([
                'status' => 'required|in:approved,rejected',
            ]);

            $letter->update([
                'status' => $request->status,
            ]);

            return response()->json([
                'success' => true,
                'message' => 'Status berhasil diupdate',
                'data' => $letter
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }

    // DELETE letter
    public function destroy($id)
    {
        try {
            $letter = Letter::findOrFail($id);
            $letter->delete();

            return response()->json([
                'success' => true,
                'message' => 'Letter berhasil dihapus'
            ], 200);
        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => $e->getMessage()
            ], 500);
        }
    }
}
