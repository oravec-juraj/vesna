
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DEVICE
%
% Device type assignment file. M-file consists of a function that provides
% the 'ID' access key of the device type being used as an output parameter.
% It requires an input parameter 'id' which contains the identifier of
% the device type in question.
%
% List of input variables
%   id            - identifier of the device type.
%
% List of output variables
%   ID            - Arduino API Cloud id identificator for the type of
%                   the used device.
%
% List of local variables
%   device        - different types of used devices.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ID = device(id)
    
% Devices ID
keySet = {'sensor','actuator'};
valueSet = {'95e254c8-7421-4d0e-bcb6-4b6991c87b4f'; % Sensors
        'aa0190a8-9312-4a17-8842-25a1dd483860'};    % Actuators
% valueSet = {'2c7b8052-e8bf-4d4f-9391-dee629d6faa5'; % Sensors
%         'acf3535f-083b-43a5-bd1c-9bae4f2f6d97'};    % Actuators
device = containers.Map(keySet,valueSet);

ID = device(id);

end
