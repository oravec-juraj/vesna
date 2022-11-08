
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% humidM
%
% Vesna greenhouse humidity control file. M-file consists of a function
% that provides the mean value of the humidity 'hum_val' and
% the control input 'pump_act' as output parameters. It requires a series
% of input parameters that are used to perform a control input of humidity
% control. The system controller is two-position (on/off), based on the
% minimal & maximal required humidity.
%
% List of input variables
%   HUM_bme       - humidity measured by BME680 sensor.
%   HUM_dht       - humidity measured by DHT11 sensor.
%   h_max         - maximum permitted humidity in the greenhouse.
%   h_min         - minimum permitted humidity in the greenhouse.
%   hum_on        - turn on the humidifier.
%   hum_off       - turn off the humidifier.
%
% List of output variables
%   hum_val       - average value of the humidity in the greenhouse.
%   hum_S         - control input for on/off humidity control.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [hum_val,hum_S] = humidM(HUM_bme,HUM_dht,h_max,h_min,hum_on, ...
                                hum_off)

% Average humidity
hum_val = (HUM_bme + HUM_dht)/2;

% Set humidity control (on/off)
if hum_val >= h_max
   propertyValue = struct('value',hum_off);
elseif hum_val <= h_min
   propertyValue = struct('value',hum_on);
else
   propertyValue = struct('value',hum_off);
end
hum_S = propertyValue;

end
