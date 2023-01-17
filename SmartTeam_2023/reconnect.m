
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% RECONNECT
%
% File to login to Arduino API Cloud. M-file consists of a function
% that does not require any input parameters. It provides the options
% parameter which contains the basic settings for MATLAB's communication
% with the Arduino API Cloud server.
%
% List of used functions
%   credentials   - loads connection credentials
%   errors        - checks the type of error that occurred
%
% List of output variables
%   options       - settings to connect to the Arduino API Cloud
%
% List of local variables
%   access_token  - Arduino API Cloud connection access token
%   client_id     - Arduino API Cloud ID
%   client_secret - Arduino API Cloud secret
%   data          - cloud connection credentials
%   headerFields  - cloud connection headerfields
%   id            - error identifier
%   response      - Arduino API Cloud response
%   spec          - e-mail send attempts
%   url           - server URL address
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function options = reconnect

% Load Arduino API Cloud credentials
data = credentials;

% Set Arduino API Cloud credetials
client_id = data{1};
client_secret = data{2};
url = "https://api2.arduino.cc/iot/v1/clients/token";

% Set connection settings
headerFields = {'Content-type','application/x-www-form-urlencoded'; ...
    'charset','UTF-8'};
options = weboptions('HeaderFields', headerFields);

spec = 0;

% Arduino API Cloud connection response
while(true)
    try
        response = webwrite(url,'client_id', client_id,'client_secret', ...
            client_secret,'grant_type','client_credentials','audience', ...
            'https://api2.arduino.cc/iot',options);
        break
    catch
        pause(5)
        spec = spec + 1;

        if ~mod(spec,5)
            errors('connect',spec);
        end
    end
end

% Response access token
access_token = response.access_token;

% Bearer token for authorization
headerFields = {'Authorization',['Bearer ',access_token]};
options = weboptions('HeaderFields',headerFields,'ContentType','json', ...
    'MediaType','auto','Timeout',10);

end
