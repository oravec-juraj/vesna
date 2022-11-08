
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% WRITE_DATA
%
% File for sending control input to Arduino API Cloud. M-file consists of
% a function that does not provide an output parameter. It requires a
% series of input parameters which contain identifiers and credentials to
% send control input to the server.
%
% List of used functions
%   errors        - check the type of error that occurred. If an error
%                   occurs, it tries to resolve it and informs the user. It
%                   requires error 'error_key' and 'spec' parameters.
%
% List of input variables
%   pid           - identifier of the used device.
%   id            - identifier of the device type.
%   data          - control input data (structure type).
%   error_key     - identifier of the error that occurred.
%   options       - settings to connect to the Arduino API Cloud.
%
% List of local variables
%   spec          - specifies to send an e-mail and display the error to
%                   the Command Window.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function write_data(pid,id,data,error_key,options)

% Initialize counter 'spec' & request method
spec = 0;
options.RequestMethod = 'put';

% Send heating off data
while(true)
    try
        webwrite(strcat("https://api2.arduino.cc/iot/v2/things/{", ...
            device(pid),"}/properties/{",d_type(id),"}/publish"), ...
            data,options);
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
