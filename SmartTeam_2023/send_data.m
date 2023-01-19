
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% SEND_DATA
%
% File for sending processed data to Arduino API Cloud. M-file consists of
% a function that does not provide any output parameter. It requires a
% series of input parameters which contain the control inputs of actuators
% in Vesna greenhouse, including door position based on neural network
% detection.
%
% List of used functions
%   reconnect     - connection to the Arduino API Cloud
%   write_data    - write data to the Arduino API Cloud
%
% List of input variables
%   doorNN        - door opening position - neural network data
%   e_k1          - control error in k-1 period
%   e_k2          - control error in k-2 period
%   fan_S         - fan control input
%   hum_S         - humidity control input
%   irr_S         - irrigation control input
%   light_S       - lighting control input
%   temp_S        - temperature control input
%   u_k1          - control input in k-1 period
%
% List of local variables
%   options       - settings to connect to the Arduino API Cloud
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function send_data(light_S,temp_S,hum_S,fan_S,e_k1,e_k2,u_k1,irr_S,doorNN)

% Connect to Arduino Cloud
options = reconnect;

% Send light control data
if light_S ~= 'n'
    write_data('actuator','lighting',light_S,'lighting',options);
end

% Send heating control data
if temp_S ~= 'n'
    write_data('actuator','heating',temp_S,'heating',options);
end

% Send pump control data
if hum_S ~= 'n'
    write_data('actuator','pump',hum_S,'pump',options);
end

% Send fan control data
if fan_S ~= 'n'
    write_data('actuator','fan',fan_S,'fan',options);
end

% Send control error in k-1 period
if e_k1 ~= 'n'
    write_data('user','e_k1',e_k1,'e_k1',options);
end

% Send control error in k-2 period
if e_k2 ~= 'n'
    write_data('user','e_k2',e_k2,'e_k2',options);
end

% Send control input in k-1 period
if u_k1 ~= 'n'
    write_data('user','u_k1',u_k1,'u_k1',options);
end

% Send irrigation control data
if irr_S ~= 'n'
    write_data('actuator','irrigator',irr_S,'irrigator',options);
end

% Send neural network control data
if irr_S ~= 'n'
    write_data('sensor','doorNN',doorNN,'doorNN',options);
end

end
