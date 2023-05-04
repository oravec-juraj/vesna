
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% lightM
%
% Vesna greenhouse lighting control file. M-file consists of a function
% that provides the lighting control input as output parameter. It requires
% a series of input parameters that are used to set a control input of
% the lighting control. The system controller is two-position (on/off),
% based on the external light intensity as well as daytime/night-time
% lighting mode.
%
% List of input variables
%   light_int     - minimum preferred light intensity
%   light_off     - turn off the light
%   light_on      - turn on the light
%   light_val     - light intensity
%   t_h           - current time hour
%   time_down     - daytime control start
%   time_up       - night-time control start
%
% List of output variables
%   u             - lighting control input
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function u = lightM(light_val,time_up,time_down,light_int,light_on, ...
    light_off,t_h)

% Lighting control input
if t_h >= time_down && t_h < time_up
    if light_val >= light_int
        u = light_off;
    else
        u = light_on;
    end
else
    u = light_off;
end

end
