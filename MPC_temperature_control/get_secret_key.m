%% TODO: Write help

function [key] = get_secret_key()

try
    data = importdata('client_secret.txt');
catch
    data = [];
end    

if(isempty(data) == 0)
    key = data{1};
else
    key = [];
end

end