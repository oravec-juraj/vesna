
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% ERRORS
%
% File for error detection during Vesna greenhouse control. M-file consists
% of a function that provides Arduino API Cloud connection options as
% an output parameter. It requires the ID input parameter which represents
% the identifier of the error that occurred during the control, as well as
% specifier of the number of function calls. The error message is
% displayed in the MATLAB Command Window. A notification e-mail with
% a description of the error is sent to the user's e-mail.
%
% List of used functions
%   email         - sends an informational email regarding the error
%   reconnect     - connects to the Arduino API Cloud
%
% List of input variables
%   id            - error identifier
%   spec          - e-mail send attempts
%
% List of output variables
%   options       - settings to connect to the Arduino API Cloud
%
% List of local variables
%   eType         - type of the detected error (error specification)
%   eMessage      - description of the detected error (error message)
%   keySet        - array of error specifications
%   valueSet1     - array of error titles
%   valueSet2     - array of error bodies
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function options = errors(id,spec)

% Error specifications
fileID = fopen('errors/error_spec.txt','r');
keySet = split(fscanf(fileID,'%s'),";");
fclose(fileID);

% Error titles
fileID = fopen('errors/error_title.txt','r');
valueSet1 = strrep(split(fscanf(fileID,'%s'),";"),'_',' ');
fclose(fileID);

% Error bodies
fileID = fopen('errors/error_body.txt','r');
valueSet2 = strrep(split(fscanf(fileID,'%s'),";"),'_',' ');
fclose(fileID);

eType = containers.Map(keySet,valueSet1);
eMessage = containers.Map(keySet,valueSet2);

% Error display
if ~mod(spec,5)
    fprintf(2,strcat(eType(id),string(datetime('now')),eMessage(id),'\n\n'))
end

% Send mail notification troubleshooting
if ~strcmp(id,'email')

    % Send mail notification after 5 unsuccessful attempts
    if ~mod(spec,5)
        email(id)
    end

    % Reconnect to Arduino API Cloud
    if ~strcmp(id,'connect')
        options = reconnect;
    end
end

end
