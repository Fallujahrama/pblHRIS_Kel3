<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class EmployeeSeeder extends Seeder
{
    public function run()
    {
        // Insert dummy departments
        DB::table('departments')->insert([
            ['id' => 1, 'name' => 'HRD', 'created_at' => now(), 'updated_at' => now()],
            ['id' => 2, 'name' => 'Keuangan', 'created_at' => now(), 'updated_at' => now()],
            ['id' => 3, 'name' => 'IT', 'created_at' => now(), 'updated_at' => now()],
            ['id' => 4, 'name' => 'Marketing', 'created_at' => now(), 'updated_at' => now()],
        ]);

        // Insert dummy positions
        DB::table('positions')->insert([
            ['id' => 1, 'name' => 'Manager', 'created_at' => now(), 'updated_at' => now()],
            ['id' => 2, 'name' => 'Staff', 'created_at' => now(), 'updated_at' => now()],
            ['id' => 3, 'name' => 'Supervisor', 'created_at' => now(), 'updated_at' => now()],
        ]);

        // Insert user dummy
        DB::table('users')->insert([
            [
                'email' => 'budi@example.com',
                'password' => Hash::make('password'),
                'is_admin' => false,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'email' => 'siti@example.com',
                'password' => Hash::make('password'),
                'is_admin' => false,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'email' => 'joko@example.com',
                'password' => Hash::make('password'),
                'is_admin' => false,
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'email' => 'admin@example.com',
                'password' => Hash::make('password'),
                'is_admin' => true,
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);

        // Get user IDs
        $budiId = DB::table('users')->where('email', 'budi@example.com')->value('id');
        $sitiId = DB::table('users')->where('email', 'siti@example.com')->value('id');
        $jokoId = DB::table('users')->where('email', 'joko@example.com')->value('id');

        // Insert employees only
        DB::table('employees')->insert([
            [
                'user_id' => $budiId,
                'position_id' => 2, // Staff
                'department_id' => 1, // HRD
                'first_name' => 'Budi',
                'last_name' => 'Santoso',
                'gender' => 'L',
                'address' => 'Malang',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'user_id' => $sitiId,
                'position_id' => 2, // Staff
                'department_id' => 2, // Keuangan
                'first_name' => 'Siti',
                'last_name' => 'Aminah',
                'gender' => 'P',
                'address' => 'Surabaya',
                'created_at' => now(),
                'updated_at' => now(),
            ],
            [
                'user_id' => $jokoId,
                'position_id' => 3, // Supervisor
                'department_id' => 1, // HRD
                'first_name' => 'Joko',
                'last_name' => 'Widodo',
                'gender' => 'L',
                'address' => 'Jakarta',
                'created_at' => now(),
                'updated_at' => now(),
            ],
        ]);

        // Letters akan diajukan manual melalui form pengajuan surat
        // Tidak perlu seed data letters di sini
    }
}
