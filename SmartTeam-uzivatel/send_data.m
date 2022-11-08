
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% SEND_DATA
%
% File for sending processed data to Arduino API Cloud. M-file consists of
% a function that does not provide an output parameter. It requires a
% series of input parameters which contain of the control inputs of
% actuators in the greenhouse.
%
% List of used functions
%   reconnect     - connection to the Arduino API Cloud which ensures data
%                   transfer between the server and the control script.
%   write_data    - write data to the Arduino API Cloud.
%
% List of input variables
%   light_S       - control input for on/off lighting control.
%   hum_on        - turn on the humidifier.
%   hum_off       - turn off the humidifier.
%   temp_S        - control input for PID controller type temperature
%                   control.
%   hum_S         - control input for on/off humidity control.
%   fan_S         - control input for on/off ventilation control.
%   door_val      - door opening position.
%
% List of local variables
%   options       - settings to connect to the Arduino API Cloud.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function send_data(light_S,hum_off,fan_off,temp_S,hum_S,fan_S,door_val)

% Connect to Arduino Cloud
options = reconnect;

%% Door open detection
if door_val == 1

% Send heating off data
write_data('actuator','heating',struct('value',0),'heating',options);

% Send pump off data
write_data('actuator','pump',struct('value',hum_off),'pump',options);

% Send fan off data
write_data('actuator','fan',struct('value',fan_off),'fan',options);

else
%% Data send to Arduino API Cloud

% Send light control data
write_data('actuator','lighting',light_S,'lighting',options);

% Send heating control data
write_data('actuator','heating',temp_S,'heating',options);

% Send pump control data
write_data('actuator','pump',hum_S,'pump',options);

% Send fan control data
write_data('actuator','fan',fan_S,'fan',options);

end
