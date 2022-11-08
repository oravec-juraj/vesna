
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% PID_con
%
% PID temperature controller of the Vesna greenhouse. M-file consists of
% a function that provides a new value of control input 'u', as well as
% previous values of control error 'e_pN' and input 'u_pN' as output
% parameters. It requires input parameter the current 'e' and the previous
% 'e_p' control error, as well as the previous value of the control output
% 'u_p'.
%
% List of input variables
%   e             - current sample control error.
%   e_p           - previous sample control error.
%   u_p           - previous sample control input.
%
% List of output variables
%   u             - current sample control input.
%   e_pN          - aktualization of the control error in previous time
%                   sampling.
%   u_pN          - aktualization of the control input in previous time
%                   sampling.
%
% List of local variables
%   Z_r           - proportional component (gain) of the PID controller.
%   T_i           - integration component (time constant) of the PID
%                   controller.
%   T_d           - derivative component (transport delay) of the PID
%                   controller.
%   u_d           - control input difference.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [u,u_pN,e_pN] = PID_con(e,e_p,u_p)

    % Reset control error & output (e(k)->e(k-1) & u(k)->u(k-1))
    u_pN = u_p;
    e_pN = e_p;

    % Controller constants
    Z_r = 45;
    T_i = 6;
    T_s = 1;

    % Control output
    u_d = Z_r*(e-e_p)+ Z_r/T_i*T_s*e;
    u = u_p+u_d;

    % Control output saturation
    if u > 255
        u = 255;
    elseif u < 0
        u = 0;
    end

% u(k) = (Kp + Ki*Δt + Kd/Δt) * e(k) - (Kp + 2*Kp/Δt) * e(k-1) +
%             + Kd/Δt * e(k-2) + u(k-1)

end
