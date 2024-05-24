
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% LOAD_DATA
%
% File for downloading data from Arduino API Cloud. M-file consists of
% a function that provides the series of loaded data as output parameters.
% It requires no input parameters. The loaded data include sensor measured
% data, physical constraints (limits) of processes, setpoints, control
% system settigs, user settings...
%
% List of used functions
%   read_data     - load and read data from Arduino API Cloud
%   reconnect     - connects to the Arduino API Cloud
%
% List of output variables
%   door_val      - door opening position
%   doorNN        - door opening position - neural network data
%   e_k1          - control error in k-1 period
%   e_k2          - control error in k-2 period
%   fan_off       - turn off the fan
%   fan_on        - turn on the fan
%   fan_S         - fan control input
%   hierarchy     - login permission access
%   h_max         - maximum preferred humidity
%   h_min         - minimum preferred humidity
%   hum_bme       - humidity (BME680 sensor)
%   hum_dht       - humidity (DHT11 sensor)
%   hum_off       - turn off the humidifier
%   hum_on        - turn on the humidifier
%   hum_S         - humidity control input
%   hum_val       - mean humidity
%   irr_S         - irrigation control input
%   light_int     - minimum preferred light intensity
%   light_off     - turn off the light
%   light_on      - turn on the light
%   light_S       - lighting control input
%   light_val     - light intensity
%   plant_id      - plant ID
%   samp          - sampling period
%   soil_hum      - soil humidity
%   time_down     - daytime control start
%   time_up       - night-time control start
%   T_bot         - temperature (bottom of the greenhouse)
%   t_d           - derivative gain
%   temp_S        - temperature control input
%   t_i           - integral gain
%   t_max         - maximum preferred temperature
%   T_top         - temperature (top of the greenhouse)
%   t_val         - mean temperature
%   u_k1          - control input in k-1 period
%   vent_dur      - ventilation duration
%   vent_start    - ventilation period
%   w_day         - daytime temperature setpoint
%   w_night       - night-time temperature setpoint
%   z_r           - proportional gain
%
% List of local functions
%   options       - settings to connect to the Arduino API Cloud
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [time_up,time_down,light_on,light_off,light_int,t_max,w_day, ...
    w_night,fan_on,fan_off,h_max,h_min,hum_on,hum_off,samp,door_val, ...
    light_val,T_top,T_bot,HUM_bme,HUM_dht,e_k1,e_k2,t_d,t_i,u_k1, ...
    vent_dur,vent_start,z_r,hierarchy,t_val,hum_val,fan_S,hum_S, ...
    light_S,temp_S,irr_S,soil_hum,plant_id,doorNN] = load_data

% Connect to Arduino API Cloud
options = reconnect;

%% Default settings

% Load default data from json file
dataX = struct2cell(jsondecode(fileread("default.json")));
data = ones(1e5,1)*-1;
k = 1;
for i = 1:length(dataX)
    dataY = struct2cell(dataX{i});
    for j = 1:length(dataY)
        data(k) = dataY{j}.Value;
        k = k + 1;
    end
end
data = data(data~=-1);

%% Loaded data (rewrite default settings)

% Loaded data types
pidS = {'sensor','actuator','user'};
idS = {'e_k1','e_k2','u_k1','hierarchy','t_i','t_d','z_r','time_down', ...
    'time_up','luminosity','light_off','light_on','temp_max','w_day', ...
    'w_night','fan_off','fan_on','hum_max','hum_min','hum_off','hum_on', ...
    'plant_id','sampling','vent_duration','vent_start','fan','pump', ...
    'lighting','heating','irrigator','door','doorNN','light','bmmeH', ...
    'dhtH','tempT','tempB','soilH'};

% Extract data values
for i = 1:length(idS)
    if i > length(idS)-8
        data(i) = read_data(pidS{1},idS{i},idS{i},options);
    elseif i > length(idS)-13
        data(i) = read_data(pidS{2},idS{i},idS{i},options);
    else
        data(i) = read_data(pidS{3},idS{i},idS{i},options);
    end
end

% Assign data values to variables
data = num2cell(data);
[e_k1,e_k2,u_k1,hierarchy,t_i,t_d,z_r,time_down,time_up,light_int, ...
 light_off,light_on,t_max,w_day,w_night,fan_off,fan_on,h_max,h_min, ...
 hum_off,hum_on,plant_id,samp,vent_dur,vent_start,fan_S,hum_S,light_S, ...
 temp_S,irr_S,door_val,doorNN,light_val,HUM_bme,HUM_dht,T_top,T_bot, ...
 soil_hum] = deal(data{:});

% Update data (if admin loads them from a file)
if plant_id ~= 0
    [t_max,w_day,w_night,h_min,h_max,time_up] = plant_set(plant_id, ...
        time_down);
end

% Adjust time data
time_down = time_down/3600;
time_up = time_up/3600;
vent_dur = vent_dur/60;
vent_start = vent_start/60;

% Average temperature, humidity
t_val = (T_top + T_bot)/2;
hum_val = (HUM_bme + HUM_dht)/2;

end
