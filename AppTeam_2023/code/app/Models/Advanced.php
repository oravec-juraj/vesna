<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class Advanced extends Model
{
    use HasApiTokens, HasFactory, Notifiable;

    protected $fillable = [
        'samplingTime',
        'P_cont',
        'I_cont',
        'D_cont',
        'duration_vent',
        'period_vent',
    ];
}
