
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% CREDENTIALS2
% 
% File to load e-mail credentials (from external file credentials2.txt).
% M-file consists of a function that does not require any input parameters.
% It provides credentials parameter which contains the basic sender's and
% receiver's e-mail credentials.
%
% List of output variables
%   data          - send e-mail credentials (sender's & recipient's
%                   e-mails, sender's e-mail password)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function data = credentials2

data = importdata("credentials2.txt");
data = {data{2};data{4};data{6}};

end
