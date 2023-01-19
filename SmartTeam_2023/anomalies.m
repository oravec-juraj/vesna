
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ANOMALIES
%
% File for detecting anomalies that arose during the control of the Vesna
% greenhouse. M-file consists of a function that does not provide any
% output parameter. It requires a series of input parameters that are used
% to detect unexpected control behaviour (anomalies) associated with Vesna
% control.
%
% List of used functions
%   email2        - sends notification e-mail
%   send_data     - sends control data to Arduino API Cloud
%
% List of input variables
%   count         - Vesna control iteration period
%   fan_off       - turn off the fan
%   fan_on        - turn on the fan
%   fan_S         - fan control input
%   HUM_avg       - humidity mean value
%   h_max         - maximum preferred humidity
%   h_min         - minimum preferred humidity
%   hum_off       - turn off the humidifier
%   hum_on        - turn on the humidifier
%   hum_S         - humidity control input
%   irr_S         - irrigation control input
%   light_int     - minimum preferred light intensity
%   light_off     - turn off the light
%   light_on      - turn on the light
%   light_S       - lighting control input
%   light_val     - light intensity
%   soil_hum      - soil humidity
%   soil_min      - minimum preferred soil humidity
%   T_avg         - temperature mean value
%   temp_S        - temperature control input
%   t_h           - current time hour
%   time_down     - daytime control start
%   time_up       - night-time control start
%   t_max         - maximum preferred temperature
%   vent_duration - ventilation duration
%   vent_start    - ventilation period
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function anomalies(T_avg,t_max,fan_S,fan_on,fan_off,count,HUM_avg, ...
    h_max,h_min,hum_S,hum_on,hum_off,t_h,time_up,time_down,light_val, ...
    light_int,light_S,light_on,light_off,temp_S,irr_S,soil_hum, ...
    vent_start,vent_duration,soil_min)

%% HEATER CONTROL ANOMALIES
if T_avg >= t_max && temp_S ~= 0
    send_data('n',0,'n','n','n','n','n','n')
    email2('temp1');
end

%% FAN CONTROL ANOMALIES

% Temperature is increased over maximum preferred value,
% but the fan is turned off
if T_avg >= t_max && fan_S == fan_off
    send_data('n','n','n',fan_on,'n','n','n','n');
    email2('fan1');
end

% Temperature is below maximum preferred value,
% but the fan is turned on (not ventilation time)
if T_avg < t_max && fan_S == fan_on && count < vent_start
    send_data('n','n','n',fan_off,'n','n','n','n');
    email2('fan2');
end

% It is time to ventilate, but the fan is turned off
if count >= vent_start && count < (vent_start+vent_duration) && ...
        fan_S == fan_off
    send_data('n','n','n',fan_on,'n','n','n','n');
    email2('vent');
end

%% PUMP CONTROL ANOMALIES

% Humidity is increased over maximum preferred value,
% but the pump is turned on
if HUM_avg >= h_max && hum_S == hum_on
    send_data('n','n',hum_off,'n','n','n','n','n');
    email2('pump1');
end

% Humidity is decreased below minimum preferred value,
% but the pump is turned off
if HUM_avg <= h_min && hum_S == hum_off
    send_data('n','n',hum_on,'n','n','n','n','n');
    email2('pump2');
end

%% LIGHTING CONTROL ANOMALIES

% Light intensity is over minimum preferred value (during the daytime
% control), but the lighting is turned on
if t_h >= time_down && t_h < time_up && light_val >= light_int && ...
        light_S == light_on
    send_data(light_off,'n','n','n','n','n','n','n');
    email2('light1');
end

% Light intensity is below minimum preferred value (during the daytime
% control), but the lighting is turned off
if t_h >= time_down && t_h < time_up && light_val < light_int && ...
        light_S == light_off
    send_data(light_on,'n','n','n','n','n','n','n');
    email2('light2');
end

% The lighting is turned on (during the night-time control)
if (t_h < time_down && t_h >= time_up) && light_S == light_on
    send_data(light_off,'n','n','n','n','n','n','n');
    email2('night');
end

%% PLANT IRRIGATION CONTROL ANOMALIES

% Soil humidity is over minimum preferred value,
% but the irrigator is turned on
if irr_S == 1 && soil_hum >= soil_min
    send_data('n','n','n','n','n','n','n',0);
    email2('irrig1');
end

% Soil humidity is below minimum preferred value,
% but the irrigator is turned off
if irr_S == 0 && soil_hum < soil_min
    send_data('n','n','n','n','n','n','n',1);
    email2('irrig2');
end

end
