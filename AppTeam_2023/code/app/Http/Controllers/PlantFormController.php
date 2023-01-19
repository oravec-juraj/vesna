<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use App\Http\Controllers\ArduinoApiController;
use GuzzleHttp\Client;
use Carbon\Carbon;

class PlantFormController extends Controller
{
    private Client $client;

    public function __construct(){                                           // Same function as in ArduinoApiController
        $this->client = new Client([
            // Base URI is used with relative requests
            'base_uri' => 'https://api2.arduino.cc',
            // You can set any number of default request options.
            //'timeout'  => 2.0,
        ]);
    }

    //--------------------------------------------------------------------------------------------------------//
    //--------------------------------------------------------------------------------------------------------//
    public function creating_pid() {                                                                //function for remembering pid in Arduino Cloud
        $pid_plant = [  'plant_id'      => 'fd49bf5e-5364-4388-807f-42af90293eac',
                        'luminosity'    => '56f41993-900f-4967-971c-b945319b18fe',
                        'temp_max'      => '5e41c37b-a509-45e0-a312-a5581506ff53',
                        'w_day'         => 'f3a47eb3-0be8-41a3-8371-feadf4d174bd',
                        'w_night'       => 'bdb32f0a-9a5f-4c11-81eb-7b953746939e',
                        'hum_min'       => 'cb95b737-2cc9-47e0-91e6-94a12b33c07b',
                        'hum_max'       => 'd8455a8d-ed70-4a3d-9236-6d7f6bf52eaf',
                        'time_up'       => '5668b8e9-4101-4dc9-ab9f-3a6727251459',
                        'time_down'     => 'e432e088-dc04-4709-8b47-dea788993b10',
        ];
        return $pid_plant;
    }

    //--------------------------------------------------------------------------------------------------------//
    //--------------------------------------------------------------------------------------------------------//
    public function get_show_values_plant(){
        $token = app('App\Http\Controllers\ArduinoApiController')->getCloudToken();                  // getting token from ArduinoApiController

        $id = 'f9d0897d-b142-4b48-9a45-7d25a28d4e79';   // cloud thing id - Vesna_user

        $crops = [1 => 'Basil', 2 => 'Parsley', 3 => 'Mint', 4 => 'Cucumber', 5 => 'Pepper', 6 => 'Tomato', 7 => 'Bean and pea',
                8 => 'Lettuce', 9 => 'Cauliflower', 10 => 'Eggplant', 11 => 'Head cabbage', 12 => 'Broccoli', 13 => 'Strawberry'];
        $pid_plant = PlantFormController::creating_pid();                                                    // getting pid_array from function above           

        foreach($pid_plant as $key => $row){                                                                // itterating the pid_plant to GET method to show last values
            $pid = $row;
                
            $response = $this->client->request('GET',"iot/v2/things/$id/properties/$pid?show_deleted=false", [
       
                'headers' => [
                    'Authorization' => 'Bearer '.$token,
                ]
            
            ]);
            ${$key.'_show'} = json_decode($response->getBody(),true)['last_value'];                         // storing the last value in variable with format etc. 'luminosity_show'

            if ($key == 'plant_id') {                                                                       
                $plant_id_show = $crops[$plant_id_show];                                                    // changing plant_id_show to string of plant, not id 
            }
            if ($key == 'time_up') {
                $time_up_show = $time_up_show/3600;                                                          // changing time from hours to seconds
            }
            if ($key == 'time_down') {
                $time_down_show = $time_down_show/3600;
            }
        }

        return view('/control/plant',                                                                       // return view with last values of variables
            ['plant_id_show'    => $plant_id_show,
            'luminosity_show'   => $luminosity_show,
            'temp_max_show'     => $temp_max_show,
            'w_day_show'        => $w_day_show,
            'w_night_show'      => $w_night_show,
            'hum_min_show'      => $hum_min_show,
            'hum_max_show'      => $hum_max_show,
            'time_up_show'      => $time_up_show,
            'time_down_show'    => $time_down_show,
            ]);
    }

    //--------------------------------------------------------------------------------------------------------//
    //--------------------------------------------------------------------------------------------------------//
    public function update_data_form_plant(Request $request) {                                              // function for updating data to Arduino Cloud from form

        $rules = [                                                                                          // rules for updating variables 
            'plant_id'          => 'nullable|string',                                                       // it need to be null or a string
            'luminosity'        => 'nullable|numeric',
            'temp_max'          => 'nullable|numeric',
            'w_day'             => 'nullable|numeric',
            'w_night'           => 'nullable|numeric',
            'hum_min'           => 'nullable|numeric',
            'hum_max'           => 'nullable|numeric',
            'time_up'           => 'nullable|integer',
            'time_down'         => 'nullable|integer',
        ];
        $validated = $request->validate($rules);                                                             // validate input parameters based on rules
    
        try {
            $d = [                                                                                           // try to take from request, a variable from control/plant with the given name 
                'plant_id'      => $request['plant_id'],
                'luminosity'    => $request['luminosity'],
                'temp_max'      => $request['temp_max'],
                'w_day'         => $request['w_day'],
                'w_night'       => $request['w_night'],
                'hum_min'       => $request['hum_min'],
                'hum_max'       => $request['hum_max'],
                'time_up'       => $request['time_up'],
                'time_down'     => $request['time_down'],
            ];

                foreach ($d as $key => $row) {                                                              // for cycle for creating varible with given name and requested value
                    $name = $key;
                    $value = $row;
                    session([$name => $value]);                                                 //putting these variables into session (to access them globally)
                }      
        } catch (Exception $e) {                                                                // if something goes wrong error will appear
                session()->flash('failure', $e->getMessage());
                return redirect()->back()->withInput();
            }

        $token = app('App\Http\Controllers\ArduinoApiController')->getCloudToken();             // getting token from ArduinoApiController
    
        $hierarchy_array = app('App\Http\Controllers\AdminGuestController')->send_hierarchy();                                          // array from AdminGuestController
        $hierarchy_array_id = $hierarchy_array['id'];
        $hierarchy_array_pid = $hierarchy_array['pid'];
        $response = $this->client->request('PUT',"iot/v2/things/$hierarchy_array_id/properties/$hierarchy_array_pid/publish", [     // we need to always update this value for the Smart team - so they know someone is controling the greenhouse
            'headers' => [
                'Authorization' => 'Bearer '.$token,
                'content-type' => 'application/json',
            ],
            'json' => [
                'value' => $hierarchy_array['value'],
            ],
        ]);

        $id = 'f9d0897d-b142-4b48-9a45-7d25a28d4e79';                                        // cloud thing id - Vesna user thing
       
        $pid_plant = PlantFormController::creating_pid();                                   // retrieve pid from first function above

        $value_plant = [];  // empty array to delete last values
        $pid_array = [];   // empty array filled by loop
        foreach($d as $key => $val){                                                        // iterable array for individual requests
            if ($key == 'plant_id' && session('plant_id') !== null){                             // if variable is not null and key = plant_id, then assign it to the pid_array
                $value_plant = PlantIDController::plant_choice_control(session('plant_id'));    // assign to a plant from PlantIDController based on ID
                $pid_array[$key] = [
                    'tag' => $pid_plant['plant_id'],                                    // cloud property id
                    'value' => $value_plant['plant_id'],                                     // The property value
                ];
            } 
            
            if ($key == 'luminosity' && session('luminosity') !== null){
                $pid_array[$key] = [
                    'tag' => $pid_plant['luminosity'],                             // cloud property id
                    'value' => floatval(session('luminosity')),                                     // The property value and changed format
                ];
            }
    
            if ($key == 'temp_max' && session('temp_max') !== null){
                $pid_array[$key] = [
                    'tag' => $pid_plant['temp_max'],                             // cloud property id
                    'value' => floatval(session('temp_max')),                                     // The property value
                ];
            }
    
            if ($key == 'w_day' && session('w_day') !== null){
                $pid_array[$key] = [
                    'tag' => $pid_plant['w_day'],                             // cloud property id
                    'value' => floatval(session('w_day')),                                     // The property value
                ];
            }
    
            if ($key == 'w_night' && session('w_night') !== null){
                $pid_array[$key] = [
                    'tag' => $pid_plant['w_night'],                             // cloud property id
                    'value' => floatval(session('w_night')),                                     // The property value
                ];
            }
    
            if ($key == 'hum_min' && session('hum_min') !== null){
                $pid_array[$key] = [
                    'tag' => $pid_plant['hum_min'],                             // cloud property id
                    'value' => floatval(session('hum_min')),                                     // The property value
                ];
            }
    
            if ($key == 'hum_max' && session('hum_max') !== null){
                $pid_array[$key] = [
                    'tag' => $pid_plant['hum_max'],                             // cloud property id
                    'value' => floatval(session('hum_max')),                                     // The property value
                ];
            }
    
            if ($key == 'time_up' && session('time_up') !== null){
                $pid_array[$key] = [
                    'tag' => $pid_plant['time_up'],                             // cloud property id
                    'value' => intval(session('time_up'))*3600,                                     // The property value
                ];
            }
    
            if ($key == 'time_down' && session('time_down') !== null){
                $pid_array[$key] = [
                    'tag' => $pid_plant['time_down'],                             // cloud property id
                    'value' => intval(session('time_down'))*3600,                                     // The property value
                ];
            }
        } 
        //dd($value_plant);
        if (count($value_plant) !== 0){                                               // if in form plant was changed, then update all values from PlantIDController based on ID
            $pid_array['plant_id'] = [
                'tag' => $pid_plant['plant_id'],                             
                'value' => $value_plant['plant_id'],                                     
            ];
            $pid_array['luminosity'] = [
                'tag' => $pid_plant['luminosity'],                             
                'value' => $value_plant['luminosity'],                                     
            ];
            $pid_array['temp_max'] = [
                'tag' => $pid_plant['temp_max'],                             
                'value' => $value_plant['temp_max'],                                     
            ];
            $pid_array['w_day'] = [
                'tag' => $pid_plant['w_day'],                             
                'value' => $value_plant['w_day'],                                     
            ];
            $pid_array['w_night'] = [
                'tag' => $pid_plant['w_night'],                             
                'value' => $value_plant['w_night'],                                     
            ];
            $pid_array['hum_min'] = [
                'tag' => $pid_plant['hum_min'],                             
                'value' => $value_plant['hum_min'],                                     
            ];
            $pid_array['hum_max'] = [
                'tag' => $pid_plant['hum_max'],                             
                'value' => $value_plant['hum_max'],                                     
            ];
            $pid_array['time_up'] = [
                'tag' => $pid_plant['time_up'],                             
                'value' => $value_plant['time_up'],                                     
            ];
            $pid_array['time_down'] = [
                'tag' => $pid_plant['time_down'],                             
                'value' => $value_plant['time_down'],                                     
            ];
        }

        foreach($pid_array as $key => $row){                                                //itteration in pid_array to send each value to Arduino Cloud
    
            $pid = $row['tag'];
            $value = $row['value'];
    
            $response = $this->client->request('PUT',"iot/v2/things/$id/properties/$pid/publish", [
       
                'headers' => [
                    'Authorization' => 'Bearer '.$token,
                    'content-type' => 'application/json',
                ],
                'json' => [
                    'value' => $value,
                ],
            ]);
        };

        if ($response->getStatusCode() == 200) {                                                            // if everything went fine green alert will appear with text
            session()->flash('success', "Plant control successfull! Please refresh the page to see updated values.");
            return redirect()->action([PlantFormController::class, 'get_show_values_plant']);        // this will return view back to show last values
        }
    }
}