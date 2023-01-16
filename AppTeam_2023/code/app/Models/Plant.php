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
        'pump_id',
        'luminosity',
        'temp_max',
        'w_day',
        'w_night',
        'hum_min',
        'hum_max',
        'time_up',
        'time_down',
    ];
}