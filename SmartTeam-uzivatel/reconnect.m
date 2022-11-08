
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% RECONNECT
% 
% File to login to Arduino Cloud Storage. M-file consists of an external
% function that does not require input parameters. It provides
% the 'options' parameter which contains the basic settings for MATLAB's
% communication with the Arduino Cloud web server.
%
% List of used functions
%   errors        - check the type of error that occurred. If an error
%                   occurs, it tries to resolve it and informs the user. It
%                   requires error 'id' and 'spec' parameters.
%
% List of output variables
%   options       - settings to connect to the Arduino API Cloud.
%
% List of local variables
%   id            - identifier of the error. Specifies the type of e-mail
%                   to send about the corresponding error.
%   spec          - specifies to send an e-mail and display the error to
%                   the Command Window.
%   response      - Arduino API Cloud response. It provides all
%                   the information about the connection to the server.
%   access_token  - access token of the Arduino API Cloud connection.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function options = reconnect

%{
    Arduino Cloud credentials
    - requires:
        - client_id     - client identifier
        - client_secret - client secret (password)
        - url           - url to web sevice
%}
client_id = "Ij7686MXMIXCS4JyGJTe5nyQNQM6w7R9";
client_secret = "BWbnmLopN6lUDPncNZ5zDmAYvHk81TQUbHWFACt9FwysSfqiBgQYhpkVeIYLtYDQ";
url = "https://api2.arduino.cc/iot/v1/clients/token";

%{
    Access specification
    - options:
        - headerFields
            - content-type - specifies type of header content
            - charset - character set
        - contentType - data format
        - mediaType - type of data send to webserver
        - timeout - available response time of the Cloud
    - webwrite:
        - API credentials
            - url, client_id, client_secret
        - grant_type - specificy type of Arduino Cloud access
        - audience - url to web page
        
%}
headerFields = {'Content-type','application/x-www-form-urlencoded'; ...
    'charset','UTF-8'};
options = weboptions('HeaderFields', headerFields);

% Initialize counter 'spec'
spec = 0;

% Arduino Cloud connection response
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
