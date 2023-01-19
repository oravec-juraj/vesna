
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% DEVICE
%
% File for assigning the ID of the type of device in use. M-file consists
% of a function that provides the ID access key of the requested device
% type as an output parameter. It requires an input ID specifier parameter
% which represents the identifier of the device type in question.
%
% List of input variables
%   id            - identifier of the demanded device type
%
% List of output variables
%   ID            - Arduino API Cloud ID identificator for the type of
%                   the demanded device
%
% List of local variables
%   device        - container of IDs of available device types
%   fileID        - loaded file ID
%   keySet        - ID specs
%   valueSet      - ID values
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function ID = device(id)
    
% ID specifications
fileID = fopen('identifiers/id_spec.txt','r');
keySet = split(fscanf(fileID,'%s'),";");
fclose(fileID);

% ID values
fileID = fopen('identifiers/id_value.txt','r');
valueSet = split(fscanf(fileID,'%s'),";");
fclose(fileID);

% Assign ID
device = containers.Map(keySet,valueSet);
ID = device(id);

end
