
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
%   heatM             - temperature control (PID controller)
%   humidM            - humidity control (on/off controller)
%   lightM            - lighting control (on/off controller)
%   load_data         - loads data from Arduino API Cloud
%   send_data         - sends data to Arduino API Cloud
%
% List of used variables
%   count             - Vesna control iteration period
%   CO2               - CO2 meassurement 
%   door_val          - door opening position
%   doorNN            - door opening position - neural network data
%   e                 - control error in k period
%   e_k1              - control error in k-1 period
%   e_k2              - control error in k-2 period
%   fan_off           - turn off the fan
%   fan_on            - turn on the fan
%   fans              - fan control input
%   hierarchy         - login permission access
%   h_max             - maximum preferred humidity
%   h_min             - minimum preferred humidity
%   hum_off           - turn off the humidifier
%   hum_on            - turn on the humidifier
%   u_hum             - humidity control input
%   hum               - humidity
%   light_off         - turn off the light
%   light_on          - turn on the light
%   u_light           - lighting control input
%   light             - light intensity
%   plant_id          - plant ID
%   samp              - sampling period
%   skip              - manipulate Vesna control loop
%   u_heat            - temperature control input
%   t_hour            - current time hour
%   time              - datetime varuiable of VESNA download
%   time1             - initialization of elapsed time
%   time_down         - daytime control start
%   time_up           - night-time control start
%   t_max             - maximum preferred temperature
%   temp              - temperature
%   u_k1              - control input in k-1 period
%   vent_dur          - ventilation duration
%   vent_start        - ventilation period
%   w_day             - daytime temperature setpoint
%   w_night           - night-time temperature setpoint
%
% !!! When interrupting the control script, it is necessary to call
%     the function 'terminator.m'. Turns off actuators in Vesna. This
%     prevention of damage to the greenhouse must be done manually. !!!
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Load configuration of VESNA from the new JSON-file 
dataX = struct2cell(jsondecode(fileread("defaultData.json")));
data_default = zeros(22,1);
m = 1;
for i = 1:length(dataX)
    dataY = struct2cell(dataX{i});
    for j = 1:length(dataY)
        data_default(m) = dataY{j}.Value;
        m = m + 1;
    end
end
data_default = num2cell(data_default);
[e_k1,e_k2,u_k1,hierarchy,time_down,time_up,light_int, ...
 light_off,light_on,t_max,w_day,w_night,fan_off,fan_on,w_hum_day,w_hum_night, ...
 hum_off,hum_on,plant_id,samp,vent_dur,vent_start] = deal(data_default{:});
% Actual hour of the day
time_down = time_down/3600;
time_up = time_up/3600;
%% Control loop
while(true)

% Start script run-time
time1 = tic;

% Current time hour
t_hour = datetime('now').Hour;
%% Load data from Arduino API Cloud
try
    [time, temp, hum, light, CO2, u_heat, u_hum, u_light, fans] = load_data(MyVesna);
catch
    disp(sprintf(' ERROR: LOAD_DATA FAILED!'))
end
%%
[time, temp, hum, light, CO2, u_heat, u_hum, u_light, fans] = load_data(MyVesna);
%% Automatic/manual greenhouse control
% if hierarchy == 0
%% Door management

% ZZZ
% Door position control function
% [skip,doorNN] = doorM(door_val);

% Skips control loop
% ZZZ
if true % skip == 0
%% Light management

% Light intensity control function
% light_S = lightM(light_val,time_up,time_down,light_int,light_on, ...
    % light_off,t_h);
%% RMPC MIMO Temperature and Humidity Management
[u_heater,u_humid,u_heat,u_hum,e_heat,e_humid,t_val,hum_val] = controlM(temp,hum,time_up,time_down,w_day,w_night,w_hum_day,w_hum_night,t_hour);

% Send heater control action to Arduino API Cloud
if (isnumeric(u_heater))
    MyVesna.upload("heater", u_heater);
end

% Send humidiser control action to Arduino API Cloud
if (isnumeric(u_humid))
    MyVesna.upload("humidiser", u_humid);
end
%%
% %% Temperature management
% 
% % Temperature heating control function
% 
% [u_heater,u_heat,e_heat,t_val] = heatM(temp,time_up,time_down, w_day,w_night,t_hour);
% 
% % Send temperature control data to Arduino API Cloud
% if (isnumeric(u_heater))
%     MyVesna.upload("heater", u_heater);
% end
% 
% %% Humidity management
% 
% % Humidifier control function
% [u_humid,u_hum,e_humid, hum_val] = humidM(hum, w_hum_day, w_hum_night, t_hour, time_up, time_down);
% if (isnumeric(u_humid))
%     MyVesna.upload("humidiser", u_humid);
% end
%% Fan management

% Fan control function
% [fan_S,count] = fanM(t_val,t_max,fan_on,fan_off,count,vent_start,vent_dur);

%% Irrigation management

% Irrigator control function
% irr_S = irrigM(soil_hum,soil_min);


% %% Sampling period
pause(samp)
% Number of sampling periods
% count = count + 1;
% % Display control status
% disp("========================")
% disp(" ")
% disp("Time:")
% disp(datetime("now"))
% disp("Iteration:")
% disp(count)
end
end