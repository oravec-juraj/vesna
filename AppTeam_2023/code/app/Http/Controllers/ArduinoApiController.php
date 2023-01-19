<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use GuzzleHttp\Client;
use Carbon\Carbon;

class ArduinoApiController extends Controller
{

    private Client $client;

    public function __construct(){
        $this->client = new Client([
            // Base URI is used with relative requests
            'base_uri' => 'https://api2.arduino.cc',
            // You can set any number of default request options.
            //'timeout'  => 2.0,
        ]);
    }


    public function getCloudToken(): string
    {

        $data = [
            'grant_type'=>  'client_credentials',
            'client_id'=>  config('services.arduino.key'),      // pulls from env through config
            'client_secret'=>  config('services.arduino.secret'),
            'audience'=>  'https://api2.arduino.cc/iot'
        ];

                $response = $this->client->request('POST', '/iot/v1/clients/token', [
            'form_params' => $data
        ]);
        
        return json_decode($response->getBody(),true)['access_token'];

    }

    public function getTimeSeriesData(){

        $token = $this->getCloudToken();    // gets auth token for requests
        $time = Carbon::now();              // gets current time
        $time_str = $time->toIso8601ZuluString();   // convert time to string format used by cloud

        $id = '2c7b8052-e8bf-4d4f-9391-dee629d6faa5';   // cloud thing id
        $desc = 1;                                      // sort datapoints from newest to oldest

        $pid_array = [                                  // iterable array for individual requests, array keys snakecase for dynamic blade rendering
            'temp_bot_3h' => [
                'pid' =>'68f17374-437c-466d-a7fc-b9b5906002b1',     // cloud property id
                'h_minus' => 3,                                     // timeframe lower boundary in hours, subtracted from current time
                'interval' => 30,                                   // interval between datapoints in seconds
            ],
            'temp_bot_48h' => [
                'pid' =>'68f17374-437c-466d-a7fc-b9b5906002b1',
                'h_minus' => 48,
                'interval' => 300,
            ],
            'temp_top_3h' => [
                'pid' =>'61e6a028-5d0d-4ae5-9684-069fed62d784',
                'h_minus' => 3,
                'interval' => 30,
            ],
            'temp_top_48h' => [
                'pid' =>'61e6a028-5d0d-4ae5-9684-069fed62d784',
                'h_minus' => 48,
                'interval' => 300,
            ],
            'hum_dht_3h' => [
                'pid' =>'d69a1c3a-0e1f-4461-bc76-727c68e2b4d3',
                'h_minus' => 3,
                'interval' => 30,
            ],
            'hum_dht_48h' => [
                'pid' =>'d69a1c3a-0e1f-4461-bc76-727c68e2b4d3',
                'h_minus' => 48,
                'interval' => 300,
            ],
            'light_3d' => [
                'pid' =>'d6653286-1d51-49d0-83b9-0dd6bf6b54fe',
                'h_minus' => 72,
                'interval' => 600,
            ],
            'light_7d' => [
                'pid' =>'d6653286-1d51-49d0-83b9-0dd6bf6b54fe',
                'h_minus' => 168,
                'interval' => 900,
            ],


        ];

        $data_batch = [];   // empty array filled by loop

        foreach($pid_array as $key => $row){

            $starttime = clone $time;   // clone to get new starttime object, instead of pointing to $time
            $starttime = $starttime->subHours($row['h_minus'])->toIso8601ZuluString();  // without cloning this would change $time
            $pid = $row['pid'];
            $interval = $row['interval'];
            
            $response = $this->client->request('GET',"/iot/v2/things/$id/properties/$pid/timeseries?from=$starttime&to=$time_str&desc=$desc&interval=$interval", [
       
                'headers' => [
                    'Authorization' => 'Bearer '.$token,
                ]
                
            ]);
            
            $data_batch[$key] = json_decode($response->getBody(),true)['data']; // add data as a nested array to $data_batch
            
        };
        
        return $data_batch;

    }

    public function getData(){
        $batch = $this->getTimeSeriesData();
        $data = json_encode($batch); // data array for iteration in blade
        $keys = array_keys($batch);  // keys array to simplify iteration in blade
        return view('statistics')->with('data', $data)->with('keys', $keys);
    }

    public function getCurrentData(){
        $token = $this->getCloudToken();
        $id = '2c7b8052-e8bf-4d4f-9391-dee629d6faa5';   // id of thing
        $pid_array = [
            'temp_bot'  =>'68f17374-437c-466d-a7fc-b9b5906002b1',   // array if property ids
            'temp_top'  =>'61e6a028-5d0d-4ae5-9684-069fed62d784',
            'hum_dht'   =>'d69a1c3a-0e1f-4461-bc76-727c68e2b4d3',
            'light'     =>'d6653286-1d51-49d0-83b9-0dd6bf6b54fe',
        ];

        $current_batch = [];   // empty array filled by loop

        foreach($pid_array as $key => $pid){
            
            $response = $this->client->request('GET',"/iot/v2/things/$id/properties/$pid", [
       
                'headers' => [
                    'Authorization' => 'Bearer '.$token,
                ]
                
            ]);
            
            $current_batch[$key] = json_decode($response->getBody(),true)['last_value']; // add data as a nested array to $current_batch
        };

        return json_encode($current_batch);
    }
}