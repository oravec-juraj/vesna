<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use App\Http\Controllers\ArduinoApiController;
use GuzzleHttp\Client;
use Carbon\Carbon;

class AdvancedFormController extends Controller
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
    public function creating_pid() {                                                                               //function for remembering pid in Arduino Cloud
        $pid_array_advanced = ['sampling'       => '99917404-2805-48ae-8a06-1e7bbb35fb4c',
                                'z_r'           => '6c988c2f-7903-4166-95fb-b0bc9a2f243b',
                                't_i'           => '8510ea80-54d4-4089-9f2a-257222ad3d72',
                                't_d'           => 'feab5946-6a23-42b9-b9f2-dc4056546801',
                                'vent_duration' => '8e569968-ba62-401f-8327-abd3423084b0',
                                'vent_start'    => 'e5d08f6e-77ee-44bb-8e69-5fb429c11745',
                            ];
        return $pid_array_advanced;
    }

    //--------------------------------------------------------------------------------------------------------//
    //--------------------------------------------------------------------------------------------------------//
    public function get_show_values_advanced(){
        $token = app('App\Http\Controllers\ArduinoApiController')->getCloudToken();  // getting token from ArduinoApiController
        $id = 'f9d0897d-b142-4b48-9a45-7d25a28d4e79';   // cloud thing id
        $pid_array_advanced = AdvancedFormController::creating_pid();   // getting pid_array from function above

        foreach($pid_array_advanced as $key => $row){                                                       // for cycle in which we send GET method to ArduinoCloud to show last value
            $pid = $row;                            
                
            $response = $this->client->request('GET',"iot/v2/things/$id/properties/$pid?show_deleted=false", [
    
                'headers' => [
                    'Authorization' => 'Bearer '.$token,
                ]
            
            ]);

            ${$key.'_show'} = json_decode($response->getBody(),true)['last_value'];                         // storing the last value in variable with format etc. 'z_r_show'
        }

        return view('/control/advanced',                                                                    // return the variables to the view, to show them in the placeholder view/control/advanced
            ['sampling_show' => $sampling_show,
            'z_r_show' => $z_r_show,
            't_i_show' => $t_i_show,
            't_d_show' => $t_d_show,
            'vent_duration_show' => $vent_duration_show,
            'vent_start_show' => $vent_start_show,
            ]);
    }


    //--------------------------------------------------------------------------------------------------------//
    //--------------------------------------------------------------------------------------------------------//
    public function update_data_form_advanced(Request $request) {                       // function for updating data to Arduino Cloud from form
        $rules = [                                                                      // rules for updating variables                        
            'sampling'          => 'nullable|integer',                                  // it need to be null or an integer
            'z_r'               => 'nullable|numeric',
            't_i'               => 'nullable|numeric',
            't_d'               => 'nullable|numeric',
            'vent_duration'     => 'nullable|integer',
            'vent_start'        => 'nullable|integer',
        ];
        $validated = $request->validate($rules);                                        // validate input parameters based on rules

        try {                                                                          // try to take from request, a variable from control/advanced with the given name 
            $d = [
                'sampling'          => $request['sampling'],
                'z_r'               => $request['z_r'],
                't_i'               => $request['t_i'],
                't_d'               => $request['t_d'],
                'vent_duration'     => $request['vent_duration'],
                'vent_start'        => $request['vent_start'],
            ];
           
                foreach ($d as $key => $row) {                                          // for cycle for creating varible with given name and requested value
                    $name = $key;
                    $value = $row;
                    session([$name => $value]);                                            //putting these variables into session (to access them globally)
                }      
        } catch (Exception $e) {                                                            // if something goes wrong error will appear
                session()->flash('failure', $e->getMessage());  
                return redirect()->back()->withInput();
            }
            //dd(session('vent_duration'));
        $token = app('App\Http\Controllers\ArduinoApiController')->getCloudToken();             // getting token from ArduinoApiController

        $hierarchy_array = app('App\Http\Controllers\AdminGuestController')->send_hierarchy();                                        // array from AdminGuestController
        $hierarchy_array_id = $hierarchy_array['id'];
        $hierarchy_array_pid = $hierarchy_array['pid'];
        $response = $this->client->request('PUT',"iot/v2/things/$hierarchy_array_id/properties/$hierarchy_array_pid/publish", [         // we need to always update this value for the Smart team - so they know someone is controling the greenhouse
            'headers' => [
                'Authorization' => 'Bearer '.$token,
                'content-type' => 'application/json',
            ],
            'json' => [
                'value' => $hierarchy_array['value'],
            ],
        ]);

        $id = 'f9d0897d-b142-4b48-9a45-7d25a28d4e79';                                           // cloud thing id - Vesna user thing
        
        $pid_array_advanced = AdvancedFormController::creating_pid();                           // getting pid_array_advanced from first function above
    
        $pid_array = [];                                                                    // empty array filled by loop
      
        foreach($d as $key => $val){                                                        // iterable array for individual requests
            if ($key == 'sampling'){                                                        // for cycle in which we assign pid with his value
                if (session('sampling') !== null){                                          // if variable is not null then assign it to the pid_array
                    $pid_array[$key] = [
                        'tag' => $pid_array_advanced['sampling'],                             // cloud property id
                        'value' => intval(session('sampling')),                                     // The property value
                    ];
                }
            }  
            if ($key == 'z_r'){
                if (session('z_r') !== null){
                    $pid_array[$key] = [
                        'tag' => $pid_array_advanced['z_r'],                             
                        'value' => floatval(session('z_r')),                                     
                    ];
                }
            }
            if ($key == 't_i') {
                if (session('t_i') !== null){
                    $pid_array[$key] = [
                        'tag' => $pid_array_advanced['t_i'],                             
                        'value' => floatval(session('t_i')),                                    
                    ];
                }
            }
            if ($key == 't_d'){
                if (session('t_d') !== null){
                    $pid_array[$key] = [
                        'tag' => $pid_array_advanced['t_d'],                             
                        'value' => floatval(session('t_d')),                                     
                    ];
                }
            }                            
            if ($key == 'vent_duration'){
                if (session('vent_duration') !== null){
                    $pid_array[$key] = [
                        'tag' => $pid_array_advanced['vent_duration'],                             
                        'value' => intval(session('vent_duration')),                                     
                    ];
                }
            }
            if ($key == 'vent_start') {
                if (session('vent_start') !== null){
                    $pid_array[$key] = [
                        'tag' => $pid_array_advanced['vent_start'],                             
                        'value' => intval(session('vent_start')),                                    
                    ];
                }
            }
        }     
   
        foreach($pid_array as $key => $row){                                                                //itteration in pid_array to send each value to Arduino Cloud

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

        if ($response->getStatusCode() == 200) {                                                                        // if everything went fine green alert will appear with text
            session()->flash('success', "Parameters updated successfully!");
            return AdvancedFormController::get_show_values_advanced();                                              // this will return view back to show last values
        }
    }    
}