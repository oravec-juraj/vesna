
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
%
% List of used variables
%   CO2               - CO2 meassurement 
%   fans              - fan control input
%   hum               - humidity
%   light             - light intensity
%   MyVesna           - VESNA greenhouse
%   temp              - temperature
%   time              - datetime variable of VESNA download
%   u_heat            - temperature control input
%   u_hum             - humidity control input
%   u_light           - lighting control input

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [time, temp, hum, light, CO2, u_heat, u_hum, u_light, fans] = load_data(MyVesna)

% Connect to Arduino API Cloud
flag_reconnect = MyVesna.reconnect();

% Download all information from VESNA
data = MyVesna.download();

% Download each parameter
time = data.temperature.time;
temp = data.temperature.value;
hum = data.humidity.value;
light = data.light_intensity.value;
CO2 = data.CO2.value;
u_heat = data.heater.value; 
u_hum = data.humidiser.value; 
u_light = data.lighting.value; 
fans = data.fans.value; 

end
