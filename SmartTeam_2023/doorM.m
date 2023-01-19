
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% doorM
%
% File for detecting the Vesna greenhouse door position. M-file consists of
% a function that provides the command to manipulate control loop based on
% door position in the greenhouse as an output parameter. It requires
% an input parameter which indicates the position of the door. If the door
% is open, in such case the control is switched to stand-by mode -
% temperature, humidity, ventilation and irrigation control input are set
% to zero, light is not affected.
%
% List of used functions
%   email2        - sends notification e-mail
%   nn_load       - neural network to detect door position
%   send_data     - sends interrupt control data to Arduino API Cloud
%
% List of input variables
%   doorNN        - door opening position - neural network data
%   door_val      - door opening position
%
% List of output variables
%   skip          - manipulate Vesna control loop
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [skip,doorNN] = doorM(door_val)

% Door control setup
if door_val == 1

    % Interrupt control loop
    send_data('n',0,0,0,'n','n','n',0,'n');
    email2('door');

    % Skip control loop
    skip = 1;

else

    % Unskip control loop
    skip = 0;

end

% Neural network - door position
doorNN = nn_load;

end
