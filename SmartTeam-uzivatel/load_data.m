
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% LOAD_DATA
%
% File for downloading data from Arduino API Cloud. M-file consists of
% a function that provides the series of loaded data as output parameters.
% It requires no input parameters. The loaded data include sensor measured
% data, physical boundaries (limits) of processes, setpoints, control
% system settigs...
%
% List of used functions
%   reconnect     - connection to the Arduino API Cloud which ensures data
%                   transfer between the server and the control script.
%   read_data     - load and read data from Arduino API Cloud.
%
% List of output variables
%   time_up       - time to switch off daylight lighting and switch to
%                   night temperature control.
%   time_down     - time to switch on daylight lighting and switch to day
%                   temperature control.
%   light_on      - turn on the light.
%   light_off     - turn off the light.
%   light_int     - minimum permitted light intensity.
%   t_max         - maximum permitted temperature in the greenhouse
%                   (controlled by a fan).
%   w_day         - daytime temperature setpoint. Timed by 'time_down' &
%                   'time_up'.
%   w_night       - night-time temperature setpoint. Timed by 'time_up' &
%                   'time_down'.
%   fan_on        - turn on the fan.
%   fan_off       - turn off the fan.
%   h_max         - maximum permitted humidity in the greenhouse (regulated
%                   by humidifier).
%   h_min         - minimum permitted humidity in the greenhouse (regulated
%                   by humidifier).
%   hum_on        - turn on the humidifier.
%   hum_off       - turn off the humidifier.
%   samp          - sampling period.
%   door_val      - door opening position.
%   light_val     - light intensity.
%   T_top         - temperature at the top of the greenhouse.
%   T_bot         - temperature at the bottom of the greenhouse.
%   hum_bme       - humidity measured by BME680 sensor.
%   hum_dht       - humidity measured by DHT11 sensor.
%
% List of local functions
%   options       - settings to connect to the Arduino API Cloud.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [time_up,time_down,light_on,light_off,light_int,t_max,w_day, ...
          w_night,fan_on,fan_off,h_max,h_min,hum_on,hum_off,samp, ...
          door_val,light_val,T_top,T_bot,HUM_bme,HUM_dht] = load_data

% Connect to Arduino Cloud
options = reconnect;

% Daytime mode
time_down = 6;          % Day start
time_up = 20;           % Day end

% Lighting
light_on = 255;         % Light is on
light_off = 0;          % Light is off
light_int = 1500;       % Min. light intensity

% Temperature
t_max = 31;             % Max. admissible temperature
w_day = 22;             % Daytime temperature setpoint
w_night = 18;           % Nighttime temperature setpoint

% Fan
fan_off = 0;            % Fan is on
fan_on = 255;           % Fan is off

% Humidity
h_max = 52;             % Min. humidity
h_min = 48;             % Max. humidity
hum_off = 0;            % Pump is on
hum_on = 255;           % Pump is off

% Sampling period time
samp = 60;

% Load door position data
door_val = read_data('sensor','door','door',options);

% Load light intensity value
light_val = read_data('sensor','light','light',options);

% Load top temperature data
T_top = read_data('sensor','tempT','tempT',options);

% Load bottom temperature data
T_bot = read_data('sensor','tempB','tempB',options);

% Load BMME humidity data
HUM_bme = read_data('sensor','bmmeH','bmmeH',options);

% Load DHT humidity data
HUM_dht = read_data('sensor','dhtH','dhtH',options);

end
