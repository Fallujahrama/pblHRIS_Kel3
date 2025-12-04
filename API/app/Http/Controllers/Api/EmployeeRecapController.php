<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use PDF;
use App\Models\Employee;
use App\Models\Departement;
use App\Models\Position;

class EmployeeRecapController extends Controller
{
    public function index()
    {
        $request = request();

        // optional filters: month=YYYY-MM, user_id
        $month = $request->query('month');
        $userId = $request->query('user_id');

        $query = Employee::with(['department', 'position', 'user', 'letters' => function ($q) use ($month) {
            if ($month) {
                [$y, $m] = array_pad(explode('-', $month), 2, null);
                if ($y && $m) {
                    $q->whereYear('created_at', $y)->whereMonth('created_at', $m);
                }
            }
        }]);

        if ($userId) {
            $query->where('id', $userId);
        }

        if ($month) {
            [$y, $m] = array_pad(explode('-', $month), 2, null);
            if ($y && $m) {
                $query->whereHas('letters', function ($q) use ($y, $m) {
                    $q->whereYear('created_at', $y)->whereMonth('created_at', $m);
                });
            }
        } else {
            $query->whereHas('letters');
        }

        $employees = $query->get();

        $recap = $employees->map(function ($employee) {
            return [
                'id' => $employee->id,
                'name' => $employee->first_name . ' ' . $employee->last_name,
                'department' => $employee->department ? $employee->department->name : null,
                'position' => $employee->position ? $employee->position->name : null,
                'gender' => $employee->gender,
                'address' => $employee->address,
                'email' => $employee->user ? $employee->user->email : null,
                'created_at' => $employee->created_at ? $employee->created_at->format('Y-m-d') : null,
                'letters' => $employee->letters->map(function ($letter) {
                    return [
                        'id' => $letter->id,
                        'name' => $letter->name,
                        'status' => $letter->status,
                    ];
                })->toArray(),
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $recap
        ])->header('Access-Control-Allow-Origin', '*')
          ->header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS')
          ->header('Access-Control-Allow-Headers', 'Content-Type, Authorization');
    }

    /**
     * Download recap as CSV. Supports same filters: month=YYYY-MM and user_id
     */
    public function download(Request $request)
    {
        $month = $request->query('month');
        $userId = $request->query('user_id');

        $query = Employee::with(['department', 'position', 'user', 'letters' => function ($q) use ($month) {
            if ($month) {
                [$y, $m] = array_pad(explode('-', $month), 2, null);
                if ($y && $m) {
                    $q->whereYear('created_at', $y)->whereMonth('created_at', $m);
                }
            }
        }]);

        if ($userId) {
            $query->where('id', $userId);
        }

        if ($month) {
            [$y, $m] = array_pad(explode('-', $month), 2, null);
            if ($y && $m) {
                $query->whereHas('letters', function ($q) use ($y, $m) {
                    $q->whereYear('created_at', $y)->whereMonth('created_at', $m);
                });
            }
        } else {
            $query->whereHas('letters');
        }

        $employees = $query->get();

        $filename = 'employee_recap' . ($month ? "_{$month}" : '') . '.csv';

        $callback = function () use ($employees) {
            $output = fopen('php://output', 'w');
            // header
            fputcsv($output, ['employee_id','employee_name','department','position','email','letter_id','letter_name','letter_status','letter_date']);

            foreach ($employees as $emp) {
                foreach ($emp->letters as $letter) {
                    fputcsv($output, [
                        $emp->id,
                        $emp->first_name . ' ' . $emp->last_name,
                        $emp->department ? $emp->department->name : '',
                        $emp->position ? $emp->position->name : '',
                        $emp->user ? $emp->user->email : '',
                        $letter->id,
                        $letter->name,
                        $letter->status,
                        $letter->created_at ? $letter->created_at->toDateString() : '',
                    ]);
                }
            }

            fclose($output);
        };

        return response()->streamDownload($callback, $filename, [
            'Content-Type' => 'text/csv; charset=UTF-8',
        ]);
    }

    /**
     * Download recap as PDF. Supports same filters: month=YYYY-MM and user_id
     */
    public function downloadPdf(Request $request)
    {
        $month = $request->query('month');
        $userId = $request->query('user_id');

        $query = Employee::with(['department', 'position', 'user', 'letters' => function ($q) use ($month) {
            if ($month) {
                [$y, $m] = array_pad(explode('-', $month), 2, null);
                if ($y && $m) {
                    $q->whereYear('created_at', $y)->whereMonth('created_at', $m);
                }
            }
        }]);

        if ($userId) {
            $query->where('id', $userId);
        }

        if ($month) {
            [$y, $m] = array_pad(explode('-', $month), 2, null);
            if ($y && $m) {
                $query->whereHas('letters', function ($q) use ($y, $m) {
                    $q->whereYear('created_at', $y)->whereMonth('created_at', $m);
                });
            }
        } else {
            $query->whereHas('letters');
        }

        $employees = $query->get();

        // Generate HTML directly without view
        $html = $this->generatePdfHtml($employees, $month);
        $pdf = PDF::loadHTML($html);

        $filename = 'employee_recap' . ($month ? "_{$month}" : '') . '.pdf';
        return $pdf->download($filename);
    }

    private function generatePdfHtml($employees, $month = null)
    {
        $periodText = $month ? 'Periode: ' . date('F Y', strtotime($month . '-01')) : 'Semua Periode';
        $printDate = date('d F Y H:i');
        
        $html = '<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Laporan Rekap Pengajuan Surat Karyawan</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            font-size: 12px;
            margin: 20px;
        }
        h2 {
            text-align: center;
            margin-bottom: 5px;
        }
        .subtitle {
            text-align: center;
            margin-bottom: 20px;
            color: #666;
        }
        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 20px;
        }
        th, td {
            border: 1px solid #333;
            padding: 8px;
            text-align: left;
        }
        th {
            background-color: #e8e8e8;
            font-weight: bold;
        }
        tr:nth-child(even) {
            background-color: #f9f9f9;
        }
        .footer {
            margin-top: 30px;
            text-align: right;
            font-size: 10px;
            color: #999;
        }
    </style>
</head>
<body>
    <h2>Laporan Rekap Pengajuan Surat Karyawan</h2>
    <div class="subtitle">' . $periodText . '</div>

    <table>
        <thead>
            <tr>
                <th style="width: 5%;">No</th>
                <th style="width: 20%;">Nama Karyawan</th>
                <th style="width: 15%;">Departemen</th>
                <th style="width: 12%;">Posisi</th>
                <th style="width: 18%;">Email</th>
                <th style="width: 15%;">Nama Surat</th>
                <th style="width: 8%;">Status</th>
                <th style="width: 7%;">Tanggal</th>
            </tr>
        </thead>
        <tbody>';

        $no = 1;
        $hasData = false;

        foreach ($employees as $emp) {
            foreach ($emp->letters as $letter) {
                $hasData = true;
                $html .= '<tr>
                    <td style="text-align: center;">' . $no++ . '</td>
                    <td>' . htmlspecialchars($emp->first_name . ' ' . $emp->last_name) . '</td>
                    <td>' . htmlspecialchars($emp->department ? $emp->department->name : '-') . '</td>
                    <td>' . htmlspecialchars($emp->position ? $emp->position->name : '-') . '</td>
                    <td>' . htmlspecialchars($emp->user ? $emp->user->email : '-') . '</td>
                    <td>' . htmlspecialchars($letter->name) . '</td>
                    <td style="text-align: center;">' . ucfirst($letter->status) . '</td>
                    <td style="text-align: center;">' . ($letter->created_at ? $letter->created_at->format('d/m/Y') : '-') . '</td>
                </tr>';
            }
        }

        if (!$hasData) {
            $html .= '<tr>
                <td colspan="8" style="text-align: center; padding: 20px;">Tidak ada data pengajuan surat</td>
            </tr>';
        }

        $html .= '</tbody>
    </table>

    <div class="footer">
        Dicetak pada: ' . $printDate . '
    </div>
</body>
</html>';

        return $html;
    }
}
