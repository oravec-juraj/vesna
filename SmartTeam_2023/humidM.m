
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% humidM
%
% File for humidifying of the Vesna greenhouse. M-file consists of
% a function that provides the mean value of the humidity and the control
% input as output parameters. It requires a series of input parameters that
% are used to set a control input of humidity regulation. The system
% controller is two-position (on/off), based on the minimum and maximum
% preferred humidity.
%
% List of input variables
%   h_max         - maximum preferred humidity
%   h_min         - minimum preferred humidity
%   HUM_bme       - humidity (BME680 sensor)
%   HUM_dht       - humidity (DHT11 sensor)
%   hum_on        - turn on the humidifier
%   hum_off       - turn off the humidifier
%
% List of output variables
%   u             - humidity control input
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function u = humidM(HUM_bme,HUM_dht,h_max,h_min,hum_on,hum_off)

% Mean humidity
hum_val = (HUM_bme + HUM_dht)/2;

% Humidity control input
if hum_val >= h_max
   u = hum_off;
elseif hum_val <= h_min
   u = hum_on;
else
   u = hum_off;
end

end
