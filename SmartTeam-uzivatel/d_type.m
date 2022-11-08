
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% D_TYPE
%
% File for the assigning of the respective device in use. M-file consists
% of a function that provides the 'PID' access key of the specific device
% being used as an output parameter. It requires an input parameter 'pid'
% which represents the identifier of the device in question.
%
% List of input variables
%   pid           - identifier of the used device.
%
% List of output variables
%   PID           - Arduino API Cloud pid identificator for the used
%                   device.
%
% List of local variables
%   type_d        - types of the different used devices.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function PID = d_type(pid)

% Sensors PID
keySet = {'light', ...
          'door', ...
          'water', ...
          'liquid', ...
          'totalML', ...
          'pump', ...
          'flow', ...
          'bmmeH', ...
          'dhtH', ...
          'meanH', ...
          'bmmeT', ...
          'dhtT', ...
          'tempT', ...
          'tempB', ...
          'meanT', ...
          'fan', ...
          'pump', ...
          'heating', ...
          'lighting'};
valueSet = {'d6653286-1d51-49d0-83b9-0dd6bf6b54fe'; % Light
        '67e83f0d-524f-433b-b478-51a5275040af';     % Doors
        '2930af3d-2b63-40c0-b557-f7453254a815';     % Water detection
        'e979475d-0b5e-474d-9c4f-29a1b5d66c6d';     % Liquid State
        '974afe32-94cc-4e49-9b74-d7f2eafeae45';     % Total mL
        'c30dc559-96dc-41d9-9d14-b00cfff2d239';     % Pump
        '179e1ae1-9410-4b6c-9d72-8bf009deb425';     % Flow rate
        '3b3eccfa-bce9-40d5-a187-a82b75bf300d';     % Humidity (BMME)
        'd69a1c3a-0e1f-4461-bc76-727c68e2b4d3';     % Humidity (DHT)
        '248bd031-8b74-4923-9264-d36b5659d061';     % Humidity (average)
        'a4e7f374-07f2-4071-ba07-f3c96a09a250';     % Temperature (BME)
        '567281db-effe-4b49-a907-1e581c463cc0';     % Temperature (DHT)
        '61e6a028-5d0d-4ae5-9684-069fed62d784';     % Temperature (top)
        '68f17374-437c-466d-a7fc-b9b5906002b1';     % Temperature (bottom)
        '8b7294c8-93e9-4ab0-911f-89ffcf3830c4';     % Temperature (average)
% Actuators PID
        '0c8a7441-7894-4d36-b4ec-7df63dfebd2a';     % Fan
        'f3fc0564-a623-43d7-a288-fc17a4f25dce';     % Pump
        'a9f0e988-ad3d-4d77-b0aa-a82abfc70c58';     % Heating
        '128d9d60-0c2f-4a58-a3e4-fb833e10bf81'};    % Lightning
type_d = containers.Map(keySet,valueSet);

PID = type_d(pid);

end

% b26776b4-a096-4883-b752-ddf6c89cc3cd - zevraj druhe PID pre Pump
