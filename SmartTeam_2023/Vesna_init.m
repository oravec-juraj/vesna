
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% VESNA_INIT
%
% File for initialization of basic variables in Vesna greenhouse control.
% M-file doesn't require any input parameters. Output parameters provide
% basic initialization (setup) of variables which entry control file even
% before control loop.
%
% List of output variables
%   count         - Vesna control iteration period
%   e_k1          - control error in k-1 period
%   e_k2          - control error in k-2 period
%   id            - summarization data ID specification
%   soil_min      - minimum preferred soil humidity
%   u_k1          - control input in k-1 period
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [count,e_k1,e_k2,u_k1,id,soil_min] = Vesna_init
    count = 0;
    e_k1 = 0;
    e_k2 = 0;
    u_k1 = 0;
    id = 0;
    soil_min = 30;
end
