
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% MPC_con
%
% TODO: Napisat dokumentaciu.
% See also: PID_con
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [u] = MPC_con(e, w0, XI0, MPC_controller)
    
    % Call the MPC controller, run "MPC_construction.m" first 
    %global MPCcontroller

    % Control output
    u_s = 128;
    out = MPC_controller(-e, w0, XI0);
    u_opt = out{1}(:,:); % Optimal control action
    x_opt = out{2}(:,:);% Predicted states
    u_mpc = u_opt(:,1); % Implemented just the first control action
    u = u_mpc + u_s; % real control action
    

    % Control output saturation
    if u > 255
        u = 255;
    elseif u < 0
        u = 0;
    end

    



end



