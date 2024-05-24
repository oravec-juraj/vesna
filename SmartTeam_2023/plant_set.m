
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PLANT_SET
%
% File for assigning plant data from local dataset. M-file consists of
% a function that provides the series of plant assigned data as output
% parameters. It requires specific plant ID and datetime control time as
% input parameters.
%
% List of input variables
%   id            - plant ID
%   time_down     - daytime control start
%
% List of output variables
%   hum_max       - maximum preferred humidity
%   hum_min       - minimum preferred humidity
%   time_up       - night-time control start
%   t_max         - maximum preferred temperature
%   w_day         - daytime temperature setpoint
%   w_night       - night-time temperature setpoint
%
% List of local functions
%   data          - loaded JSON plant data
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [t_max,w_day,w_night,hum_min,hum_max,time_up] = plant_set(id, ...
    time_down)

data = struct2cell(jsondecode(fileread("plants.json")));
t_max = -1*ones(length(data),1);
w_day = -1*ones(length(data),1);
w_night = -1*ones(length(data),1);
hum_min = -1*ones(length(data),1);
hum_max = -1*ones(length(data),1);
time_up = -1*ones(length(data),1);
for i = 1:length(data)
    t_max(i) = data{i}.temp_max;
    w_day(i) = data{i}.w_day;
    w_night(i) = data{i}.w_night;
    hum_min(i) = data{i}.hum_min;
    hum_max(i) = data{i}.hum_max;
    time_up(i) = data{i}.exposure+time_down;
end
t_max = t_max(id);
w_day = w_day(id);
w_night = w_night(id);
hum_min = hum_min(id);
hum_max = hum_max(id);
time_up = time_up(id);

end
