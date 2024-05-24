
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% VESNA_CONTROL
%
% Vesna intelligent greenhouse control script. M-file provides
% comprehensive management of several measured variables of the system,
% including diagnostics of problems, detection of emerging anomalies,
% or providing support to the user.
%
% Variables control in the code is decentralized. Each controlled variable
% (temperature, humidity, lighting, soil humidity), including door position
% detection based on neural network model and greenhouse ventilation, is
% based on external functions, creating individual control sections of
% Vesna. They download (measured) data from the Arduino API Cloud, where
% the values of control output are subsequently sent. In the event of
% a malfunction, the user is informed by e-mail, while programm tries to
% solve the emerged problem. A summary e-mail at the end of the day will
% provide the user with an overview of contrl settings during the day.
% Another option is to change the control from automatic to manual, when
% the user controls the measured quantities himself.
%
% List of used functions
%   anomalies         - detects unexpected control behaviour (anomalies)
%                       and sends a signal to eliminate them
%   doorM             - detects door position on Vesna. If they are open,
%                       sends a command to turn off the contol (set
%                       stand-by mode)
%   fanM              - temperature & ventilation control (on/off
%                       controller)
%   heatM             - temperature control (PID controller)
%   humidM            - humidity control (on/off controller)
%   irrigM            - irrigation control (on/off controller)
%   lightM            - lighting control (on/off controller)
%   load_data         - loads data from Arduino API Cloud
%   send_data         - sends data to Arduino API Cloud
%   smmr              - sends summarization data e-mail to user
%   Vesna_init        - initialization basic variables
%
% List of used variables
%   count             - Vesna control iteration period
%   door_val          - door opening position
%   doorNN            - door opening position - neural network data
%   e                 - control error in k period
%   e_k1              - control error in k-1 period
%   e_k2              - control error in k-2 period
%   fan_off           - turn off the fan
%   fan_on            - turn on the fan
%   fan_S             - fan control input
%   hierarchy         - login permission access
%   h_max             - maximum preferred humidity
%   h_min             - minimum preferred humidity
%   HUM_bme           - humidity (BME680 sensor)
%   HUM_dht           - humidity (DHT11 sensor)
%   hum_off           - turn off the humidifier
%   hum_on            - turn on the humidifier
%   hum_S             - humidity control input
%   hum_val           - mean humidity
%   id                - identifier for sending summarization e-mail
%   irr_S             - irrigation control input
%   light_off         - turn off the light
%   light_on          - turn on the light
%   light_S           - lighting control input
%   light_val         - light intensity
%   plant_id          - plant ID
%   samp              - sampling period
%   skip              - manipulate Vesna control loop
%   soil_hum          - soil humidity
%   soil_min          - minimum preferred soil humidity
%   T_bot             - temperature (bottom of the greenhouse)
%   t_d               - derivative gain
%   temp_S            - temperature control input
%   t_h               - current time hour
%   t_i               - integral gain
%   time1             - initialization of elapsed time
%   time_down         - daytime control start
%   time_up           - night-time control start
%   t_max             - maximum preferred temperature
%   T_top             - temperature (top of the greenhouse)
%   t_val             - mean temperature
%   u_k1              - control input in k-1 period
%   vent_dur          - ventilation duration
%   vent_start        - ventilation period
%   w_day             - daytime temperature setpoint
%   w_night           - night-time temperature setpoint
%   z_r               - proportional gain
%
% !!! When interrupting the control script, it is necessary to call
%     the function 'terminator.m'. Turns off actuators in Vesna. This
%     prevention of damage to the greenhouse must be done manually. !!!
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization
[count,e_k1,e_k2,u_k1,id,soil_min] = Vesna_init;

%% Control loop
while(true)

% Start script run-time
time1 = tic;

% Current time hour
t_h = datetime('now').Hour;

%% Load data from Arduino API Cloud

[time_up,time_down,light_on,light_off,light_int,t_max,w_day,w_night, ...
    fan_on,fan_off,h_max,h_min,hum_on,hum_off,samp,door_val,light_val, ...
    T_top,T_bot,HUM_bme,HUM_dht,e_k1,e_k2,t_d,t_i,u_k1,vent_dur, ...
    vent_start,z_r,hierarchy,t_val,hum_val,fan_S,hum_S,light_S,temp_S, ...
    irr_S,soil_hum,plant_id,doorNN] = load_data;

%% Detect anomalies

anomalies(t_val,t_max,fan_S,fan_on,fan_off,count,hum_val,h_max,h_min, ...
    hum_S,hum_on,hum_off,t_h,time_up,time_down,light_val,light_int, ...
    light_S,light_on,light_off,temp_S,irr_S,soil_hum,vent_start, ...
    vent_dur,soil_min)

%% Automatic/manual greenhouse control

if hierarchy == 0

%% Door management

% Door position control function
[skip,doorNN] = doorM(door_val);

% Skips control loop
if skip == 0

%% Light management

% Light intensity control function
light_S = lightM(light_val,time_up,time_down,light_int,light_on, ...
    light_off,t_h);

%% Temperature management

% Temperature heating control function
[temp_S,e,u_k1,e_k1,e_k2,t_val] = heatM(T_top,T_bot,time_up,time_down, ...
    w_day,w_night,e_k1,e_k2,u_k1,t_h,z_r,t_i,t_d,samp/60);

%% Humidity management

% Humidifier control function
hum_S = humidM(HUM_bme,HUM_dht,h_max,h_min,hum_on,hum_off);

%% Fan management

% Fan control function
[fan_S,count] = fanM(t_val,t_max,fan_on,fan_off,count,vent_start,vent_dur);

%% Irrigation management

% Irrigator control function
irr_S = irrigM(soil_hum,soil_min);

end
end

%% Send data to Arduino API Cloud
send_data(light_S,temp_S,hum_S,fan_S,e_k1,e_k2,u_k1,irr_S,doorNN);

% Send day data summary (once a day)
if time_up <= t_h
    id = smmr(id,t_h,time_down,time_up,light_int,t_max,w_day, ...
    w_night,h_max,h_min,samp,vent_start,vent_dur,door_val,light_val, ...
    T_top,T_bot,HUM_bme,HUM_dht,z_r,t_i,t_d,temp_S,fan_S,hum_S,light_S, ...
    soil_hum,irr_S);
end

%% Loop settings

if hierarchy == 0

% Check script run-time
time2 = toc(time1);
if time2 > samp
    samp = samp - mod(time2,samp);
else
    samp = samp - time2;
end

% Sampling period time
pause(samp)

% Number of sampling periods
count = count + 1;

% Display control status
disp("========================")
disp(" ")
disp("Time:")
disp(datetime("now"))
disp("Iteration:")
disp(count)

else
    pause(3)
end

end
