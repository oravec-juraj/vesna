
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
% (temperature, humidity, lighting), including door position detection and
% greenhouse ventilation, is based on external functions, creating
% individual control sections of Vesna. They download (measured) data from
% the Arduino API Cloud, where the values of control output are
% subsequently sent. In the event of a malfunction, the user is informed by
% e-mail, while programm tries to solve the emerged problem.
%
% List of used functions
%   load_data         - load data from Arduino API Cloud - control inputs,
%                       control outputs, setpoints, limits...
%   doorM             - detect the opening of the door - sends a command
%                       to turn off Vesna.
%   lightM            - check whether sufficient lighting of the greenhouse
%                       is ensured depending on the day/night mode.
%   heatM             - temperature control in the greenhouse using a PID
%                       controller.
%   humidM            - humidity control in the greenhouse using an on/off
%                       controller.
%   fanM              - temperature & ventilation control in the greenhouse
%                       using an on/off controller.
%   send_data         - send data to Arduino API Cloud - control inputs,
%                       door position.
%
% List of used variables
%   control script
%       count         - iteration cycle number. Used in function/s fanM.m,
%                       anomalies.m.
%       e_p           - initialization of control error. Used in function/s
%                       heatM.m.
%       u_p           - initialization of control input. Used in function/s
%                       heatM.m.
%       t_h           - current time hour. Used in function/s lightM.m,
%                       heatM.m, anomalies.m.
%       time1         - initialization of elapsed time.
%       time2         - ETL elapsed time in script operation mode.
%   load_data
%       time_up       - time to switch off daylight lighting and switch to
%                       night temperature control. Used in function/s
%                       lightM.m, heatM.m, anomalies.m.
%       time_down     - time to switch on daylight lighting and switch to
%                       day temperature control. Used in function/s
%                       lightM.m, heatM.m, anomalies.m.
%       light_on      - turn on the light. Used in function/s lightM.m,
%                       anomalies.m.
%       light_off     - turn off the light. Used in function/s lightM.m,
%                       anomalies.m.
%       light_int     - minimum permitted light intensity. Used in
%                       function/s lightM.m, anomalies.m.
%       t_max         - maximum permitted temperature in the greenhouse
%                       (regulated by a fan). Used in function/s fanM.m,
%                       anomalies.m.
%       w_day         - daytime temperature setpoint. Timed by 'time_down'
%                       & 'time_up'. Used in function/s heatM.m.
%       w_night       - night-time temperature setpoint. Timed by 'time_up'
%                       & 'time_down'. Used in function/s heatM.m.
%       fan_on        - turn on the fan. Used in function/s fanM.m,
%                       anomalies.m.
%       fan_off       - turn off the fan. Used in function/s fanM.m,
%                       anomalies.m.
%       h_max         - maximum permitted humidity in the greenhouse
%                       (regulated by humidifier). Used in function/s
%                       humidM.m, anomalies.m.
%       h_min         - minimum permitted humidity in the greenhouse
%                       (regulated by humidifier). Used in function/s
%                       humidM.m, anomalies.m.
%       hum_on        - turn on the humidifier. Used in function/s
%                       humidM.m, anomalies.m.
%       hum_off       - turn off the humidifier. Used in function/s
%                       humidM.m, anomalies.m.
%       samp          - sampling period.
%       door_val      - door opening position. Used in function/s doorM.m,
%                       send_data.m.
%       light_val     - light intensity. Used in function/s lightM.m,
%                       anomalies.m.
%       T_top         - temperature at the top of the greenhouse. Used in
%                       function/s heatM.m.
%       T_bot         - temperature at the bottom of the greenhouse. Used
%                       in function/s heatM.m.
%       hum_bme       - humidity measured by BME680 sensor. Used in
%                       function/s humidM.m.
%       hum_dht       - humidity measured by DHT11 sensor. Used in
%                       function/s humidM.m.
%   doorM
%       skip          - skip current control period.
%   lightM
%       light_S       - control input for on/off lighting control. Used in
%                       function/s send_data.m, anomalies.m.
%   heatM
%       temp_S        - control input for PID controller type temperature
%                       control. Used in function/s send_data.m.
%       t_val         - average value of the temperature in the greenhouse.
%                       Used in function/s fanM.m, anomalies.m.
%   humidM
%       hum_S         - control input for on/off humidity control. Used in
%                       function/s send_data.m, anomalies.m.
%       hum_val       - average value of the humidity in the greenhouse.
%                       Used in function/s anomalies.m.
%   fanM
%       fan_S         - control input for on/off ventilation control. Used
%                       in function/s send_data.m, anomalies.m.
%
% !!! When interrupting the control script, it is necessary to call
%     the function terminator.m. Turns off actuators in Vesna. This
%     prevention of damage to the greenhouse must be done manually. !!!
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Initialization

% Ventilation cycle counter
count = 0;

% Control error e(k-1) and control output e(k-1) at previous sample
e_p = 0;
u_p = 0;

%% Control loop
while(true)

% Start script run-time
time1 = tic;

% Current time hour
t_h = datetime('now').Hour;

%% Load data from Arduino API Cloud
[time_up,time_down,light_on,light_off,light_int,t_max,w_day,w_night, ...
    fan_on,fan_off,h_max,h_min,hum_on,hum_off,samp,door_val,light_val, ...
    T_top,T_bot,hum_bme,hum_dht] = load_data;

%% Door management

% Door position control function
skip = doorM(door_val);

% Skips control loop
if skip == 0

%% Light management

% Light intensity control function
light_S = lightM(light_val,time_up,time_down,light_int,light_on, ...
                light_off,t_h);

%% Temperature management

% Temperature heating control function
[temp_S,t_val,u_p,e_p] = heatM(T_top,T_bot,time_up,time_down,w_day, ...
                            w_night,e_p,u_p,t_h);

%% Humidity management

% Humidity control function
[hum_val,hum_S] = humidM(hum_bme,hum_dht,h_max,h_min,hum_on,hum_off);

%% Fan management

% Fan control function
[fan_S,count] = fanM(t_val,t_max,fan_on,fan_off,count);

%% Send data to Arduino API Cloud
send_data(light_S,hum_off,fan_off,temp_S,hum_S,fan_S,door_val);

end
%% Loop settings

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

end
