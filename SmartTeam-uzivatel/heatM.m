
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% heatM
%
% Vesna greenhouse temperature control file. M-file consists of a function
% that provides the value of the control input 'temp_S' and the mean value
% of the temperature 't_val', as well as current sample control error 'e_pN'
% and input 'u_pN' as output parameters. It requires a series of input
% parameters that are used to perform a control input of temperature
% regulation. System uses the PID type of controller.
%
% List of used functions
%   PID_con       - proportional-integral-derivative type of controller.
%
% List of input variables
%   T_top         - temperature at the top of the greenhouse.
%   T_bot         - temperature at the bottom of the greenhouse.
%   time_up       - time to switch off daylight lighting and switch to
%                   night temperature control.
%   time_down     - time to switch on daylight lighting and switch to
%                   day temperature control.
%   w_day         - daytime temperature setpoint.
%   w_night       - night-time temperature setpoint.
%   e_p           - control error in previous time sampling.
%   u_p           - control input in previous time sampling.
%   t_h           - current time hour.
%
% List of output variables
%   temp_S        - control input for PID controller type temperature
%                   control.
%   t_val         - average value of the temperature in the greenhouse.
%   e_pN          - aktualization of the control error in previous time
%                   sampling.
%   u_pN          - aktualization of the control input in previous time
%                   sampling.
%
% List of local variables
%   w             - current temperature setpoint.
%   e             - current control error.
%   u             - current control input.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [temp_S,t_val,u_pN,e_pN] = heatM(T_top,T_bot,time_up,time_down, ...
                                    w_day,w_night,e_p,u_p,t_h)

% Average temperature
t_val = (T_top + T_bot)/2;

% Temperature setpoint
if t_h >= time_down && t_h < time_up
    w = w_day;
else 
    w = w_night;
end

% Control error
e =  w-t_val;

% Control output
[u,u_pN,e_pN] = PID_con(e,e_p,u_p);
temp_S = struct('value',u);

end
