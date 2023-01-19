
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% READ_DATA
%
% File for reading data from Arduino API Cloud. M-file consists of
% a function that provides data to be loaded from cloud server. It
% requires a series of input parameters which contain identifiers and
% credentials to load required data from the cloud server.
%
% List of used functions
%   errors        - checks the type of error that occurred
%
% List of input variables
%   error_key     - identifier of the error type
%   id            - identifier of the demanded device type
%   options       - settings to connect to the Arduino API Cloud
%   pid           - identifier of the demanded device
%
% List of output variables
%   data_val      - loaded data value from Arduino API Cloud
%
% List of local variables
%   data          - loaded data from Arduino API Cloud
%   spec          - e-mail send attempts
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function data_val = read_data(pid,id,error_key,options)

% Initialize counter 'spec' & request method
spec = 0;
options.RequestMethod = 'auto';

% Load last data value
while(true)
    try
        if id(1) == '_'
            data = webread(strcat("https://api2.arduino.cc/iot/v2/things/{", ...
                device(pid),"}/properties/{",d_type(id(2:end)), ...
                "}/timeseries?desc=true&interval=3"),options);
        else
            data = webread(strcat("https://api2.arduino.cc/iot/v2/things/{", ...
                device(pid),"}/properties/{",d_type(id),"}"),options);
        end
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
if id(1) == '_'
    data_val = data;
else
    data_val = data.last_value;
end

end
