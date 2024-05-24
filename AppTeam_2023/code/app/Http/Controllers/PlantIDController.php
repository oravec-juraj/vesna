<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use GuzzleHttp\Client;
use Carbon\Carbon;

class PlantIDController extends Controller
{
    public static function plant_choice_control($plant_id) {
        $plant_optimal = [];
        if ($plant_id == 'Basil'){
            $plant_optimal['plant'] = 'Basil';
            $plant_optimal['plant_id'] = 1;
            $plant_optimal['luminosity'] = 1500;
            $plant_optimal['temp_max'] = 25;
            $plant_optimal['w_day'] = 22.5;
            $plant_optimal['w_night'] = 19;
            $plant_optimal['hum_min'] = 90;
            $plant_optimal['hum_max'] = 95;
            $plant_optimal['time_up'] = 72000;
            $plant_optimal['time_down'] = 28800;
        } 
        
        elseif ($plant_id == 'Parsley') {
            $plant_optimal['plant'] = 'Parsley';
            $plant_optimal['plant_id'] = 2;
            $plant_optimal['luminosity'] = 1500;
            $plant_optimal['temp_max'] = 29;
            $plant_optimal['w_day'] = 25.5;
            $plant_optimal['w_night'] = 17.5;
            $plant_optimal['hum_min'] = 50;
            $plant_optimal['hum_max'] = 95;
            $plant_optimal['time_up'] = 72000;
            $plant_optimal['time_down'] = 28800;
        } 
        
        elseif ($plant_id == 'Mint') {
            $plant_optimal['plant'] = 'Mint';
            $plant_optimal['plant_id'] = 3;
            $plant_optimal['luminosity'] = 1500;
            $plant_optimal['temp_max'] = 24;
            $plant_optimal['w_day'] = 21;
            $plant_optimal['w_night'] = 14;
            $plant_optimal['hum_min'] = 40;
            $plant_optimal['hum_max'] = 55;
            $plant_optimal['time_up'] = 72000;
            $plant_optimal['time_down'] = 28800;
        }  
        
        elseif ($plant_id == 'Cucumber') {
            $plant_optimal['plant'] = 'Cucumber';
            $plant_optimal['plant_id'] = 4;
            $plant_optimal['luminosity'] = 1500;
            $plant_optimal['temp_max'] = 28;
            $plant_optimal['w_day'] = 25;
            $plant_optimal['w_night'] = 19;
            $plant_optimal['hum_min'] = 85;
            $plant_optimal['hum_max'] = 95;
            $plant_optimal['time_up'] = 72000;
            $plant_optimal['time_down'] = 28800;
        }  
        
        elseif ($plant_id == 'Pepper') {
            $plant_optimal['plant'] = 'Pepper';
            $plant_optimal['plant_id'] = 5;
            $plant_optimal['luminosity'] = 1500;
            $plant_optimal['temp_max'] = 30;
            $plant_optimal['w_day'] = 26;
            $plant_optimal['w_night'] = 18;
            $plant_optimal['hum_min'] = 50;
            $plant_optimal['hum_max'] = 70;
            $plant_optimal['time_up'] = 72000;
            $plant_optimal['time_down'] = 21600;
        }  
        
        elseif ($plant_id == 'Tomato') {
            $plant_optimal['plant'] = 'Tomato';
            $plant_optimal['plant_id'] = 6;
            $plant_optimal['luminosity'] = 1500;
            $plant_optimal['temp_max'] = 20;
            $plant_optimal['w_day'] = 24;
            $plant_optimal['w_night'] = 17.5;
            $plant_optimal['hum_min'] = 65;
            $plant_optimal['hum_max'] = 85;
            $plant_optimal['time_up'] = 72000;
            $plant_optimal['time_down'] = 21600;
        } 
        
        elseif ($plant_id == 'Bean and pea') {
            $plant_optimal['plant'] = 'Bean and pea';
            $plant_optimal['plant_id'] = 7;
            $plant_optimal['luminosity'] = 1500;
            $plant_optimal['temp_max'] = 28;
            $plant_optimal['w_day'] = 24.5;
            $plant_optimal['w_night'] = 17;
            $plant_optimal['hum_min'] = 60;
            $plant_optimal['hum_max'] = 75;
            $plant_optimal['time_up'] = 72000;
            $plant_optimal['time_down'] = 21600;
        } 
        
        elseif ($plant_id == 'Lettuce') {
            $plant_optimal['plant'] = 'Lettuce';
            $plant_optimal['plant_id'] = 8;
            $plant_optimal['luminosity'] = 1500;
            $plant_optimal['temp_max'] = 22;
            $plant_optimal['w_day'] = 18.5;
            $plant_optimal['w_night'] = 14;
            $plant_optimal['hum_min'] = 50;
            $plant_optimal['hum_max'] = 70;
            $plant_optimal['time_up'] = 72000;
            $plant_optimal['time_down'] = 28800;
        } 
        
        elseif ($plant_id == 'Cauliflower') {
            $plant_optimal['plant'] = 'Cauliflower';
            $plant_optimal['plant_id'] = 9;
            $plant_optimal['luminosity'] = 1500;
            $plant_optimal['temp_max'] = 19;
            $plant_optimal['w_day'] = 17.5;
            $plant_optimal['w_night'] = 13;
            $plant_optimal['hum_min'] = 80;
            $plant_optimal['hum_max'] = 95;
            $plant_optimal['time_up'] = 72000;
            $plant_optimal['time_down'] = 28800;
        } 
        
        elseif ($plant_id == 'Eggplant') {
            $plant_optimal['plant'] = 'Eggplant';
            $plant_optimal['plant_id'] = 10;
            $plant_optimal['luminosity'] = 1500;
            $plant_optimal['temp_max'] = 26;
            $plant_optimal['w_day'] = 24;
            $plant_optimal['w_night'] = 16.5;
            $plant_optimal['hum_min'] = 50;
            $plant_optimal['hum_max'] = 65;
            $plant_optimal['time_up'] = 72000;
            $plant_optimal['time_down'] = 21600;
        }  
        
        elseif ($plant_id == 'Head cabbage') {
            $plant_optimal['plant'] = 'Head cabbage';
            $plant_optimal['plant_id'] = 11;
            $plant_optimal['luminosity'] = 1500;
            $plant_optimal['temp_max'] = 21;
            $plant_optimal['w_day'] = 19.5;
            $plant_optimal['w_night'] = 16.5;
            $plant_optimal['hum_min'] = 60;
            $plant_optimal['hum_max'] = 90;
            $plant_optimal['time_up'] = 72000;
            $plant_optimal['time_down'] = 28800;
        } 
        
        elseif ($plant_id == 'Broccoli') {
            $plant_optimal['plant'] = 'Broccoli';
            $plant_optimal['plant_id'] = 12;
            $plant_optimal['luminosity'] = 1500;
            $plant_optimal['temp_max'] = 21;
            $plant_optimal['w_day'] = 19.5;
            $plant_optimal['w_night'] = 15.5;
            $plant_optimal['hum_min'] = 80;
            $plant_optimal['hum_max'] = 95;
            $plant_optimal['time_up'] = 72000;
            $plant_optimal['time_down'] = 28800;
        } 
        
        elseif ($plant_id == 'Strawberry') {
            $plant_optimal['plant'] = 'Strawberry';
            $plant_optimal['plant_id'] = 13;
            $plant_optimal['luminosity'] = 1500;
            $plant_optimal['temp_max'] = 26;
            $plant_optimal['w_day'] = 23;
            $plant_optimal['w_night'] = 14.5;
            $plant_optimal['hum_min'] = 60;
            $plant_optimal['hum_max'] = 75;
            $plant_optimal['time_up'] = 72000;
            $plant_optimal['time_down'] = 21600;
        } 

        return $plant_optimal;
    }
}