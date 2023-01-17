
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% WRITE_DATA
%
% File for sending control input to Arduino API Cloud. M-file consists of
% a function that does not provide any output parameters. It requires a
% series of input parameters which contain identifiers and credentials to
% send control input to the server.
%
% List of used functions
%   errors        - checks the type of error that occurred
%
% List of input variables
%   data          - data value to send to Arduino API Cloud
%   error_key     - identifier of the error type
%   id            - identifier of the demanded device type
%   options       - settings to connect to the Arduino API Cloud
%   pid           - identifier of the demanded device
%
% List of local variables
%   spec          - e-mail send attempts
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function write_data(pid,id,data,error_key,options)

% Initialize counter & request method
spec = 0;
options.RequestMethod = 'put';

% Send heating off data
while(true)
    try
        webwrite(strcat("https://api2.arduino.cc/iot/v2/things/{", ...
            device(pid),"}/properties/{",d_type(id),"}/publish"), ...
            struct('value',data),options);
        break
    catch
        pause(5)
        spec = spec + 1;

        % Terminates after 5 attempts
        if ~mod(spec,5)
            options = errors(error_key,spec);
        end
        options.RequestMethod = 'put';
    end
end

end
