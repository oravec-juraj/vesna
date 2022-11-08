
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% READ_DATA
%
% File for reading data from Arduino API Cloud. M-file consists of
% a function that provides data 'data_val' to be loaded from server. It
% requires a series of input parameters which contain identifiers and
% credentials to load required data from the server.
%
% List of used functions
%   errors        - check the type of error that occurred. If an error
%                   occurs, it tries to resolve it and informs the user. It
%                   requires error 'error_key' and 'spec' parameters.
%
% List of input variables
%   pid           - identifier of the used device.
%   id            - identifier of the device type.
%   error_key     - identifier of the error that occurred.
%   options       - settings to connect to the Arduino API Cloud.
%
% List of output variables
%   data_val      - loaded data from Arduino API Cloud.
%
% List of local variables
%   spec          - specifies to send an e-mail and display the error to
%                   the Command Window.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function data_val = read_data(pid,id,error_key,options)

% Initialize counter 'spec' & request method
spec = 0;
options.RequestMethod = 'auto';

% Load last data value
while(true)
    try
        data = webread(strcat("https://api2.arduino.cc/iot/v2/things/{", ...
            device(pid),"}/properties/{",d_type(id),"}"),options);
        break
    catch
        pause(5)
        spec = spec + 1;
        % Terminates after 5 attempts
        if ~mod(spec,5)
            options = errors(error_key,spec);
        end
        options.RequestMethod = 'auto';
    end
end
data_val = data.last_value;

end
