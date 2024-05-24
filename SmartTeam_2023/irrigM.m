
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% irrigM
%
% File for irrigating of the Vesna greenhouse. M-file consists of
% a function that provides the irrigator control input as output parameter.
% It requires the soil humidity and minimum preferred soil humidity as
% input parameters. The system controller is two-position (on/off),
% based on the minimum preferred soil humidity.
%
% List of input variables
%   soil_hum      - soil humidity
%   soil_min      - minimum preferred soil humidity
%
% List of output variables
%   u             - irrigator control input
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function u = irrigM(soil_hum,soil_min)

% Soil humidity control input
if soil_hum < soil_min
    u = 1;
else
    u = 0;
end

end
