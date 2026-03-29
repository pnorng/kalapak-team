<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class UserSeeder extends Seeder
{
    public function run(): void
    {
        // Admin
        User::firstOrCreate(
            ['email' => 'admin@kalapak.team'],
            [
                'name' => 'Khat Vanna',
                'password' => Hash::make('kalapak@2024'),
                'role' => 'admin',
            ]
        );

        // Team members as regular users
        $members = [
            ['name' => 'Rom Chamraeun', 'email' => 'rom@kalapak.team'],
            ['name' => 'Phuem Norng', 'email' => 'phuem@kalapak.team'],
            ['name' => 'Pheun Seanghai', 'email' => 'pheun@kalapak.team'],
        ];

        foreach ($members as $member) {
            User::firstOrCreate(
                ['email' => $member['email']],
                [
                    'name' => $member['name'],
                    'password' => Hash::make('kalapak@2024'),
                    'role' => 'user',
                ]
            );
        }
    }
}
