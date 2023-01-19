
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PID_con
%
% File for setting the control input of the PID controller. M-file consists
% of a function that provides the series of control output parameters. It
% requires a series of input parameters to set control input.
%
% List of input variables
%   e             - control error in k period
%   e_p1          - control error in k-1 period
%   e_p2          - control error in k-2 period
%   T_d           - derivative gain
%   T_i           - integral gain
%   T_s           - sampling period (in minutes)
%   u_p1          - control input in k-1 period
%   Z_r           - proportional gain
%
% List of output variables
%   e_pN1         - update control error in k-1 period
%   e_pN2         - update control error in k-2 period
%   u             - control input in k period
%   u_pN1         - update control input in k-1 period
%
% List of local variables
%   u_d           - control input difference
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [u,u_pN1,e_pN1,e_pN2] = PID_con(e,e_p1,e_p2,u_p1,Z_r,T_i,T_d,T_s)

% Update control error & output
u_pN1 = u_p1;
e_pN2 = e_p1;
e_pN1 = e_p2;

% Temperature control input
u_d = Z_r*(e-e_p1 + T_s/T_i*e + T_d/T_s*(e-2*e_p1+e_p2));
u = u_p1 + u_d;

% Control input saturation
if u > 255
    u = 255;
elseif u < 0
    u = 0;
end

end
