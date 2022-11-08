
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% lightM
%
% Vesna greenhouse lighting control file. M-file consists of a function
% that provides the control input 'light_S' as output parameter. It
% requires a series of input parameters that are used to perform a control
% input of the lighting control. The system controller is two-position
% (on/off), based on the external light intensity as well as daytime/night-
% time lighting mode.
%
% List of input variables
%   light_val     - light intensity.
%   time_up       - time to switch off daylight lighting and switch to
%                   night temperature control.
%   time_down     - time to switch on daylight lighting and switch to day
%                   temperature control.
%   light_int     - minimum permitted light intensity.
%   light_on      - turn on the light.
%   light_off     - turn off the light.
%   t_h           - current time hour.
%
% List of output variables
%   light_S       - control input for on/off lighting control.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function light_S = lightM(light_val,time_up,time_down,light_int, ...
                          light_on,light_off,t_h)

% Set light control (on/off)
if t_h >= time_down && t_h < time_up
    if light_val > light_int
        propertyValue = struct('value',light_off);
    else
        propertyValue = struct('value',light_on);
    end
else
    propertyValue = struct('value',light_off);
end
light_S = propertyValue;

end
