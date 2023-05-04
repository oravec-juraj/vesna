
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% heatM
%
% File for heating of the Vesna greenhouse. M-file consists of a function
% that provides the value of the control input and error in current and
% previous sampling pariod (and control error in k-2 period) and the mean
% value of the measured temperature. It requires a series of input
% parameters that are used to set a control input of temperature
% regulation. System uses the PID type of controller.
%
% List of used functions
%   PID_con       - incremental proportional-integral-derivative type of
%                   controller
%
% List of input variables
%   e_p           - temperature control error in k period
%   T_bot         - temperature (bottom of the greenhouse)
%   t_h           - current time hour
%   time_down     - daytime control start
%   time_up       - night-time control start
%   T_top         - temperature (top of the greenhouse)
%   u_p           - temperature control input in k period
%   w_day         - daytime temperature setpoint
%   w_night       - night-time temperature setpoint
%
% List of output variables
%   e             - temperature control error in k period
%   e_pN1         - update temperature control error in k-1 period
%   e_pN2         - update temperature control error in k-2 period
%   t_val         - mean temperature
%   u             - temperature control input in k period
%   u_pN1         - update temperature control input in k-1 period
%
% List of local variables
%   w             - temperature setpoint in k period
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [u,e,u_pN1,e_pN1,e_pN2,t_val] = heatM(T_top,T_bot,time_up,time_down, ...
    w_day,w_night,e_p1,e_p2,u_p1,t_h,Z_r,T_i,T_d,T_s)

% Mean temperature
t_val = (T_top + T_bot)/2;

% Temperature setpoint
if t_h >= time_down && t_h < time_up
    w = w_day;
else
    w = w_night;
end

% Temperature control error
e = w-t_val;

%Integral of control error: augmented vector of system states
% x_tilde = [ e; XI]
global XI
XI = XI + e;

% Temperature control input
% [u,u_pN1,e_pN1,e_pN2] = PID_con(e,e_p1,e_p2,u_p1,Z_r,T_i,T_d,T_s);
global MPC_controller
[u] = MPC_con(e, w, XI, MPC_controller)
u_pN = [];
e_pN = [];
u_pN1 = [];
e_pN1 = [];
e_pN2 = [];

global Ww Yy Uu
Ww = [Ww, w];
Yy = [Yy; t_val];
Uu = [Uu; u];

%% ZZZ
% temp_S = struct('value',u);


%% Log data
% [t u y]
try
    load('mpc_data_log');
catch
    mpc_data_table = [];
end
datetime.setDefaultFormats('default', 'yyyy-MM-dd''T''HH:mm:ss'); % set default time format
mpc_data_table = [mpc_data_table; timetable([u], [t_val], [w], 'RowTimes', datetime)]
save mpc_data_log mpc_data_table
end
