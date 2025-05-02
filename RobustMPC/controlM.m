
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% controlM
%
% File for heating of the Vesna greenhouse. M-file consists of a function
% that provides the value of the control input and error in current and
% previous sampling pariod (and control error in k-2 period) and the mean
% value of the measured temperature. It requires a series of input
% parameters that are used to set a control input of temperature
% regulation. System uses the MPC type of controller.
%
% List of used functions
%   iMPC           - robust MPC type of
%                   controller
%
% List of input variables
%   t_hour        - current time hour
%   time_down     - daytime control start
%   time_up       - night-time control start
%   temp          - temperature (top of the greenhouse)
%   w_day         - daytime temperature setpoint
%   w_night       - night-time temperature setpoint
%   w_hum_day     - daytime temperature setpoint
%   w_hum_night   - night-time temperature setpoint
%
% List of output variables
%   e_heat        - temperature control error in k period
%   e_humid       - temperature control error in k period
%   t_val         - temperature
%   hum_val       - temperature
%   u_heat        - temperature control input in k period
%   u_hum         - humidity control input in k period
%   u_heater      - temperature control input in k period to API Cloud
%   u_humid       - humidity control input in k period to API Cloud
%
% List of local variables
%   w_day             - temperature setpoint in k period during day
%   w_night           - temperature setpoint in k period during night
%   w_hum_day         - humidity setpoint in k period during day
%   w_hum_night       - humidity setpoint in k period during night
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [u_heater,u_humid,u_heat,u_hum,e_heat,e_humid,t_val,hum_val] = controlM(temp,hum,time_up,time_down,w_day,w_night,w_hum_day,w_hum_night,t_hour);

% Mean temperature
t_val = temp;

% Temperature setpoint
if t_hour >= time_down && t_hour < time_up
    w_heat = w_day;
else
    % w_heat = w_night;
    w_heat = w_day;
end

% Mean humidity
hum_val = hum;

% Humidity setpoint
if t_hour >= time_down && t_hour < time_up
    w_humid = w_hum_day;
else
    % w_humid = w_hum_night;
    w_humid = w_hum_day;
end

% Temperature control error
e_heat = -w_heat+t_val;
T_int = [];
%Integral of control error: augmented vector of system states
% x_tilde = [ e; XI]
global XI_heat
XI_heat = XI_heat - e_heat;
T_int = [T_int; XI_heat];
% Temperature control input
x0_heat = [e_heat;XI_heat];

% Humidity control error
e_humid = -w_humid+hum_val;
H_int = [];
%Integral of control error: augmented vector of system states
% x_tilde = [ e; XI]
global XI_humid
XI_humid = XI_humid - e_humid;
H_int = [H_int; XI_humid];
% Temperature control input
x0_humid = [e_humid;XI_humid];

global iMPC
[u_control] = iMPC.evaluate([x0_heat; x0_humid]);

u_heat_s = 128;
u_humid_s = 13;

u_heat = u_control(1)
u_hum = u_control(2)

u_heat = u_heat + u_heat_s; % real heater control action
u_hum = u_hum + u_humid_s; % real humidiser control action

global Ww_heat Yy_heat Uu_heat
Ww_heat = [Ww_heat, w_heat];
Yy_heat = [Yy_heat; t_val];
Uu_heat = [Uu_heat; u_heat];

global Ww_hum Yy_hum Uu_hum
Ww_hum = [Ww_hum, w_humid];
Yy_hum = [Yy_hum; hum_val];
Uu_hum = [Uu_hum; u_hum];

% Control output temperature saturation
    if u_heat > 255
        u_heat = 255;
    elseif u_heat < 0
        u_heat = 0;
    end

% Control output humidity saturation
    if u_hum > 25
        u_hum = 25;
    elseif u_hum < 0
        u_hum = 0;
    end

u_humid = u_hum;
u_heater = u_heat*(20/51);

%% Log temperature data
% [t u y]
try
    load('mpc_data_log_heat');
catch
    mpc_data_table_heat = [];
end
datetime.setDefaultFormats('default', 'yyyy-MM-dd''T''HH:mm:ss'); % set default time format
mpc_data_table_heat = [mpc_data_table_heat; timetable([u_heater], [t_val], [w_heat], 'RowTimes', datetime)]
save mpc_data_log_heat mpc_data_table_heat
%% Log humidity data
% [t u y]
try
    load('mpc_data_log_humid');
catch
    mpc_data_table_humid = [];
end
datetime.setDefaultFormats('default', 'yyyy-MM-dd''T''HH:mm:ss'); % set default time format
mpc_data_table_humid = [mpc_data_table_humid; timetable([u_humid], [hum_val], [w_humid], 'RowTimes', datetime)]
save mpc_data_log_humid mpc_data_table_humid
end