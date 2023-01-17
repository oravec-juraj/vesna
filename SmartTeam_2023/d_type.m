
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% D_TYPE
%
% File for assigning the PID of the device in use. M-file consists of
% a function that provides the PID access key of the requested device as
% an output parameter. It requires an input PID specifier parameter which
% represents the identifier of the device in question.
%
% List of input variables
%   pid           - identifier of the demanded device
%
% List of output variables
%   PID           - Arduino API Cloud PID identificator for the demanded
%                   device
%
% List of local variables
%   fileID        - loaded file PID
%   keySet        - PID specs
%   type_d        - container of PIDs of available devices
%   valueSet      - PID values
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function PID = d_type(pid)

% PID specifications
fileID = fopen('identifiers/pid_spec.txt','r');
keySet = split(fscanf(fileID,'%s'),";");
fclose(fileID);

% PID values
fileID = fopen('identifiers/pid_value.txt','r');
valueSet = split(fscanf(fileID,'%s'),";");
fclose(fileID);

% Assign PID
type_d = containers.Map(keySet,valueSet);
PID = type_d(pid);

end
