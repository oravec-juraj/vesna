
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% TERMINATOR
%
% File for turning off control of Vesna. M-file does not require any input
% or output parameters. It terminates the control cycle and turns off all
% actuators in the greenhouse. This MUST be called after inturrapting
% 'vesna_control' to prevent the undesirable behaviour and damage of the
% system device.
%
% List of used functions
%   reconnect     - connection to the Arduino API Cloud which ensures data
%                   transfer between the server and the control script.
%   write_data    - write data to the Arduino API Cloud. All values are set
%                   to zero.
%
% List of local variables
%   options       - settings to connect to the Arduino API Cloud.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function terminator

% Connect to Arduino Cloud
options = reconnect;

% Send heating off data
write_data('actuator','heating',struct('value',0),'heating',options);

% Send pump off data
write_data('actuator','pump',struct('value',0),'pump',options);

% Send fan off data
write_data('actuator','fan',struct('value',0),'fan',options);

% Send light off data
write_data('actuator','lighting',struct('value',0),'lighting',options);

imshow('terminator.jpg')

end
