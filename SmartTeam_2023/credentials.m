
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CREDENTIALS
% 
% File to load Arduino API Cloud connection credentials (from external file
% credentials.txt). M-file consists of a function that does not require any
% input parameters. It provides credentials parameter which contains
% Arduino API Cloud connection credentials.
%
% List of output variables
%   data          - Arduino API Cloud connection credentials (id & secret)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function data = credentials

data = importdata("credentials.txt");
data = {data{2};data{4}};

end
