<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use App\Http\Controllers\ArduinoApiController;
use GuzzleHttp\Client;
use Carbon\Carbon;

class EnvironmentFormController extends Controller
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
    public function creating_pid() {                                                    //function for remembering the pid 
        $pid_control = ['lighting'  => '128d9d60-0c2f-4a58-a3e4-fb833e10bf81',
                        'pump'      => 'f3fc0564-a623-43d7-a288-fc17a4f25dce',
                        'fans'      => '0c8a7441-7894-4d36-b4ec-7df63dfebd2a',
                        'irrigator' => 'd7b7f72e-05aa-4a30-a053-a30a98f75f16',
                     ];
        return $pid_control;
    }

    //--------------------------------------------------------------------------------------------------------//
    //--------------------------------------------------------------------------------------------------------//
    public function get_show_values_control(){
        $token = app('App\Http\Controllers\ArduinoApiController')->getCloudToken();  // getting token from ArduinoApiController

        $id = 'aa0190a8-9312-4a17-8842-25a1dd483860';   // cloud thing id - Vesna_act

        $pid_control = EnvironmentFormController::creating_pid();           // taking pid from function above

        foreach($pid_control as $key => $row){                                  // for cycle in which we send GET method to ArduinoCloud to show last value
            
            $pid = $row;
                
            $response = $this->client->request('GET',"iot/v2/things/$id/properties/$pid?show_deleted=false", [
       
                'headers' => [
                    'Authorization' => 'Bearer '.$token,
                ]
            
            ]);
            ${$key.'_show'} = json_decode($response->getBody(),true)['last_value'];     // storing the last value in variable with format etc. 'lighting_show'

            if ($key == 'lighting') {                                                   
                if ($lighting_show == 255) {                                            // if it was turn on then add to the form radio checked
                    $lighting_show_on = 'checked';
                    $lighting_show_off = '';                                                
                } else {                                                                // else check off radio
                    $lighting_show_on = '';
                    $lighting_show_off = 'checked';
                }
            }
            if ($key == 'pump') {
                if ($pump_show == 255) {
                    $pump_show_on = 'checked';
                    $pump_show_off = '';
                } else {
                    $pump_show_on = '';
                    $pump_show_off = 'checked';
                }
            }
            if ($key == 'fans') {
                if ($fans_show == 255) {
                    $fans_show_on = 'checked';
                    $fans_show_off = '';
                } else {
                    $fans_show_on = '';
                    $fans_show_off = 'checked';
                }
            }
            if ($key == 'irrigator') {
                if ($irrigator_show == 255) {
                    $irrigator_show_on = 'checked';
                    $irrigator_show_off = '';
                } else {
                    $irrigator_show_on = '';
                    $irrigator_show_off = 'checked';
                }
            }
        }
        //dd($pump_show);
        return view('/control/environment',                                 // return the variables to the view, to show them in the placeholder view/control/environment
            ['lighting_show_on'     => $lighting_show_on,
            'lighting_show_off'     => $lighting_show_off,
            'pump_show_on'          => $pump_show_on,
            'pump_show_off'         => $pump_show_off,
            'fans_show_on'          => $fans_show_on,
            'fans_show_off'         => $fans_show_off,
            'irrigator_show_on'     => $irrigator_show_on,
            'irrigator_show_off'    => $irrigator_show_off,
            ]);
    }

    //--------------------------------------------------------------------------------------------------------//
    //--------------------------------------------------------------------------------------------------------//
    public function update_data_form_control(Request $request) {                    // function for updating data to Arduino Cloud from form
        //dd($request);
        $rules = [                                                                  // rules for updating variables  
            'pump'              => 'nullable|string',                               // it need to be null or a string
            'lighting'          => 'nullable|string',
            'fans'              => 'nullable|string',
            'irrigator'         => 'nullable|string',
        ];
        $validated = $request->validate($rules);                                    // validate input parameters based on rules

        try {                                                                        // try to take from request, a variable from control/environment with the given name
            $d = [
                'pump'          => $request['pump'],
                'lighting'      => $request['lighting'],
                'fans'          => $request['fans'],
                'irrigator'     => $request['irrigator'],
            ];

            foreach ($d as $key => $row) {                                          // for cycle for creating varible with given name and requested value
                $name = $key;
                $value = $row;
                session([$name => $value]);                                         //putting these variables into session (to access them globally)
            }      
        } catch (Exception $e) {                                                    // if something goes wrong error will appear
                session()->flash('failure', $e->getMessage());
                return redirect()->back()->withInput();
            }
        
        $token = app('App\Http\Controllers\ArduinoApiController')->getCloudToken();                 // getting token from ArduinoApiController

        $hierarchy_array = app('App\Http\Controllers\AdminGuestController')->send_hierarchy();                                      // array from AdminGuestController
        $hierarchy_array_id = $hierarchy_array['id'];
        $hierarchy_array_pid = $hierarchy_array['pid'];
        $response = $this->client->request('PUT',"iot/v2/things/$hierarchy_array_id/properties/$hierarchy_array_pid/publish", [ // we need to always update this value for the Smart team - so they know someone is controling the greenhouse
            'headers' => [
                'Authorization' => 'Bearer '.$token,
                'content-type' => 'application/json',
            ],
            'json' => [
                'value' => $hierarchy_array['value'],
            ],
        ]);

        $id = 'f9d0897d-b142-4b48-9a45-7d25a28d4e79';   // cloud thing id - Vesna user thing
        
        $pid_control = EnvironmentFormController::creating_pid();           // getting pid_control from first function above
        
        $pid_array = [];   // empty array filled by loop
        foreach($d as $key => $val){  
            //dd($val);                                                        // iterable array for individual requests
            if ($key == 'lighting' && session('lighting') !== null){                          // for cycle in which we assign pid with his value
                if ($val == 'Turn on lighting'){
                    $pid_array[$key] = [                                                    // if variable is not null and key='lighting' then assign it to the pid_array
                        'tag' => $pid_control['lighting'],                             // cloud property id
                        'value' => 255,                                     // The property value
                    ];
                } elseif ($val == 'Turn off lighting'){
                    $pid_array[$key] = [
                        'tag' => $pid_control['lighting'],                             // cloud property id
                        'value' => 0,                                     // The property value
                    ];
                } 
            } 
            if ($key === 'pump' && session('pump') !== null){
                //dd($val);
                if ($val === 'Turn on humidification'){
                    $pid_array[$key] = [
                        'tag' => $pid_control['pump'],                             
                        'value' => 255,                                     
                    ];
                } elseif ($val === 'Turn off humidification'){
                    $pid_array[$key] = [
                        'tag' => $pid_control['pump'],                             
                        'value' => 0,                                     
                    ];
                }
            }
            if ($key == 'fans' && session('fans') !== null) {
                if ($val == 'Turn on the fan'){
                    $pid_array[$key] = [
                        'tag' => $pid_control['fans'],                             
                        'value' => 255,                                    
                    ];
                } elseif ($val == 'Turn off the fan'){
                    $pid_array[$key] = [
                        'tag' => $pid_control['fans'],                             
                        'value' => 0,                                     
                    ];
                }
            }
            if ($key == 'irrigator' && session('irrigator') !== null){
                if ($val == 'Turn on irrigation'){
                    $pid_array[$key] = [
                        'tag' => $pid_control['irrigator'],                             
                        'value' => 255,                                     
                    ];
                } elseif ($val == 'Turn off irrigation'){
                    $pid_array[$key] = [
                        'tag' => $pid_control['irrigator'],                             
                        'value' => 0,                                     
                    ];
                }
            }                            
        }     

        foreach($pid_array as $key => $row){                                                                        //itteration in pid_array to send each value to Arduino Cloud

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

        if ($response->getStatusCode() == 200) {                        // if everything went fine green alert will appear with text
            session()->flash('success', "Control successfull!");
            return EnvironmentFormController::get_show_values_control();        // this will return view back to show last values
        }
    }       
}