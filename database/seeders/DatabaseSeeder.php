<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    /**
     * Demo accounts (see DummyDataSeeder):
     * - demo@lifeos.test / password
     * - alex@lifeos.test / password
     */
    public function run(): void
    {
        $this->call(DummyDataSeeder::class);
    }
}
