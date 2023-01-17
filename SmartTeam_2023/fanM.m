
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% fanM
%
% File for cooling and ventilation of the Vesna greenhouse. M-file consists
% of a function that provides the value of the control input and
% the current value of the sampling period as output parameters. It
% requires a series of input parameters that are used to set an control
% input for fan. The system controller is two-position (on/off), based on
% maximum preferred temperature, respectively ventilation cycle.
%
% List of input variables
%   count         - Vesna control iteration period
%   fan_off       - turn off the fan
%   fan_on        - turn on the fan
%   T_avg         - temperature mean value
%   t_max         - maximum preferred temperature
%   vent_duration - ventilation duration
%   vent_start    - ventilation period 
%
% List of output variables
%   countN        - 'count' variable update
%   u             - fan control input
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [u,countN] = fanM(T_avg,t_max,fan_on,fan_off,count,vent_start, ...
    vent_dur)

% Fan control input
if count >= vent_start
    u = fan_on;
    if count >= (vent_dur+vent_start)
        count = -1;
        if T_avg >= t_max
            u = fan_on;
        else
            u = fan_off;
        end
    end
elseif T_avg >= t_max
    u = fan_on;
else
    u = fan_off;
end

% Update 'count'
countN = count;

end
