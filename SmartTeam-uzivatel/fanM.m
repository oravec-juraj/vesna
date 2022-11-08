
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% fanM
%
% Vesna greenhouse cooling and ventilation control file. M-file consists of
% a function that provides the value of the control input 'fan_act' and
% the current value of the sampling period 'countN' as output parameters.
% It requires a series of input parameters that are used to perform
% an control input of temperature reduction and ventilation. The system
% controller is two-position (on/off), based on maximal .
%
% List of input variables
%   T_avg         - average value of the temperature in the greenhouse.
%   t_max         - maximum permitted temperature in the greenhouse.
%   fan_on        - turn on the fan.
%   fan_off       - turn off the fan.
%   count         - iteration cycle number.
%
% List of output variables
%   fan_S         - control input for on/off ventilation control.
%   countN        - actualization of 'count' variable.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [fan_S,countN] = fanM(T_avg,t_max,fan_on,fan_off,count)

% Set fan control (on/off)
if count >= 120
    propertyValue = struct('value',fan_on);
    if count >= 135
        count = -1;
        if T_avg >= t_max
            propertyValue = struct('value',fan_on);
        else
            propertyValue = struct('value',fan_off);
        end
    end
elseif T_avg >= t_max
    propertyValue = struct('value',fan_on);
else
    propertyValue = struct('value',fan_off);
end
fan_S = propertyValue;

% Rewrite count
countN = count;

end
