%%
clear 
close all
clc
%%
% This .m file is designed for Robust MPC MIMO control on greenhouse VESNA start.
% It consists of connnecting to Arduino Cloud by getting Arduino API credentials,
% rmpc_con.m for MPC controller and vesna_control.m for VESNA
% control. This was created as a part of master thesis 
% 'Robust Model Predictive Control Design for a  Smart Greenhouse' by
% B.Daras
%% !!! ALWAYS RUN THIS SECTION FIRST, BEFORE 'vesna_control.m' TO SEE IF CREDENTIALS AND MPC CONTROLLER IS OK. !!!
run('C:\Users\Brano\Documents\MATLAB\tbxmanager\toolboxes\vesna\R20240424\all\vesna_code\vesna_credentials_json.m'); % AFTER installing VESNA toolbox, change user name (Brano in this case) in the path.
MyVesna = vesna;
MyVesna.connect(url, login, password)
%%
rmpc_con 
%% !!! RUN THIS SECTION AFTER THE PREVIOUS !!!
vesna_control