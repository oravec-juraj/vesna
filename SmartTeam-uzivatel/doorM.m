
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% doorM
%
% Vesna greenhouse door position detection file. M-file consists of
% a function that provides the command 'skip' to turn off the control in
% the greenhouse as an output parameter. It requires an input parameter
% 'door_val' which numerically indicates the position of the door. If
% the door is ajar, in such case the control is switched to stand-by mode -
% temperature, humidity and ventilation control are switched off, light
% stays on.
%
% List of used functions
%   send_data     - send data to Arduino API Cloud - control inputs, door
%                   position.
%   email2        - send notification e-mail about detected opened door. It
%                   requires email 'door' id parameter.
%
% List of input variables
%   door_val      - door opening position.
%
% List of output variables
%   skip          - command to turn off the Vesna regulation (activated by
%                   the presence of an open door).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function skip = doorM(door_val)

% Security during the open house (only light is functioning)
if door_val

    % Interrupt control loop
    send_data(0,0,0,0,0,0,1);

    % Send notification email
    email('open');

    % Skip control loop
    skip = 1;

else
    
    % Unskip control loop
    skip = 0;

end

end
