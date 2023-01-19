<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

use Illuminate\Support\Str;
use App\Models\User;

class UserSeeder extends Seeder
{
    /**
     * Run the database seeds.
     *
     * @return void
     */
    public function run()
    {
        User::create([
            'name'              => 'User',
            'surname'           => 'One', 
            'email'             => config('services.credentials.user_email'), 
            'email_verified_at' => now(),
            'password'          => bcrypt(config('services.credentials.user_pass')), 
            'remember_token'    => Str::random(10),
            'created_at'        => now(),
            'is_admin'          => 0, 
        ]);

        User::create([
            'name'              => 'Admin',
            'surname'           => 'One',  
            'email'             => config('services.credentials.admin_email'), 
            'email_verified_at' => now(),
            'password'          => bcrypt(config('services.credentials.admin_pass')), 
            'remember_token'    => Str::random(10),
            'created_at'        => now(),
            'is_admin'          => 1, 
        ]);
    }
}
