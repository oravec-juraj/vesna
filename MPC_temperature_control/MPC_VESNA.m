%%
clear all
close all
clc
%%
% This .m file is designed for simple MPC control on greenhouse VESNA start.
% It consists of credentials.m for getting Arduino API credentials,
% MPC_construction.m for MPC controller and vesna_control.m for VESNA
% control. This was created as a part of bachelor thesis 
% 'Model Predictive Control Design for a Prototype of Smart Greenhouse' bz
% B.Daras
%% !!! ALWAYS RUN THIS SECTION FIRST, BEFORE 'vesna_control.m' TO SEE IF CREDENTIALS AND MPC CONTROLLER IS OK. !!!
run('credentials.m'); % credentials.text needed (not in a repository)
%%
run('MPC_construction.m');
%% !!! RUN THIS SECTION AFTER THE PREVIOUS !!!
run('vesna_control.m')