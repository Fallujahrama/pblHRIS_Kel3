<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class LetterFormatSeeder extends Seeder
{
    public function run()
    {
        DB::table('letter_formats')->insert([
            [
                'name' => 'Surat Izin Tidak Masuk Kerja',
                'content' => "
                    SURAT IZIN TIDAK MASUK KERJA

                    Kepada Yth,
                    HRD / Atasan Langsung

                    Dengan ini saya, {{nama}}, mengajukan permohonan izin 
                    tidak dapat masuk kerja pada tanggal {{tanggal}} 
                    karena keperluan mendesak.

                    Jenis Surat: {{jenis_surat}}

                    Demikian permohonan ini saya sampaikan. 
                    Atas pengertian dan kebijaksanaannya saya ucapkan terima kasih.
                ",
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Surat Sakit Tidak Masuk Kerja',
                'content' => "
                    SURAT SAKIT TIDAK MASUK KERJA

                    Kepada Yth,
                    HRD / Atasan Langsung

                    Dengan ini saya, {{nama}}, tidak dapat masuk kerja 
                    pada tanggal {{tanggal}} karena kondisi kesehatan 
                    yang kurang baik.

                    Jenis Surat: {{jenis_surat}}

                    Demikian pemberitahuan ini saya sampaikan. 
                    Atas perhatian dan pengertiannya saya ucapkan terima kasih.
                ",
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'name' => 'Surat Tugas Bekerja di Luar Kantor',
                'content' => "
                    SURAT TUGAS BEKERJA DI LUAR KANTOR

                    Dengan ini memberikan tugas kepada:

                    Nama: {{nama}}

                    Untuk melaksanakan pekerjaan di luar kantor 
                    pada tanggal {{tanggal}} sesuai kebutuhan operasional.

                    Jenis Surat: {{jenis_surat}}

                    Demikian surat tugas ini dibuat untuk dipergunakan 
                    sebagaimana mestinya.
                ",
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);
    }
}
