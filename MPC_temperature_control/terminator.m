
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% TERMINATOR
%
% File for turning off control of Vesna. M-file does not require any input
% or output parameters. It terminates the control cycle and turns off all
% actuators in the greenhouse. This MUST be called after inturrapting
% main Vesna control file to prevent the undesirable behaviour and damage
% of the system device.
%
% List of used functions
%   reconnect     - connects to the Arduino API Cloud
%   write_data    - write data to the Arduino API Cloud
%
% List of local variables
%   options       - settings to connect to the Arduino API Cloud
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function terminator

% Connect to Arduino API Cloud
options = reconnect;

% Send heating off data
write_data('actuator','heating',struct('value',0),'heating',options);

% Send pump off data
write_data('actuator','pump',struct('value',0),'pump',options);

% Send fan off data
write_data('actuator','fan',struct('value',0),'fan',options);

% Send light off data
write_data('actuator','lighting',struct('value',0),'lighting',options);

% Send irrigation off data
write_data('actuator','irrigator',struct('value',0),'irrigator',options);

imshow('terminator.jpg')

end
