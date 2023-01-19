<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use App\Http\Controllers\ArduinoApiController;

class AdminGuestController extends Controller
{
    public function send_hierarchy(){                           // function for updating the hierarchy everytime some variable will be published
        $array = [
            'id' => 'f9d0897d-b142-4b48-9a45-7d25a28d4e79',        // id of the thing
            'pid' => 'c39a0b37-4788-4992-be22-cab32f501e28',        // pid of the variable
            'value' => 1,                                           // 1 for webside control 
        ];

        return $array;
    }
}