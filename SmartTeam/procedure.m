%% Open communication and wait until connection is established
clc; clear all; close all;
addpath(genpath('flexy2'))

a = Flexy2;
%a.calibrate

Ts = 0.01;
%% Step testing
start_speed = 70;
setLed(a, start_speed)
pause(4)
addpath(genpath('identification'))
% Run step tests for specified step sizes

[y, t, u] = stepled(a,'StepAmpPerc',20, ...
                    'NumSteps',10, 'Ts', Ts, ...
                    'InputOffset', start_speed);

setFanSpeedPerc(a, 0)
%close(a)

%% Save the data
% Save as .mat
filetime = datestr(now,'yyyymmddHHMMSS');
save(sprintf('%s_fan_%s.mat',filetime, 'data'), 'y', 't', 'u')

%% Make preprocessing
addpath(genpath('identification'))

% TODO: change the parameters relative to Ts
[u_mean, y_mean, idx] = preprocessData(data);

%% Identify system parameters of the specified order 
Ts = 0.01;
idtf = recursiveLeastSquares(u_mean, y_mean, Ts, 1, 2, 'PlotConv', false);

%% Plot open loop simulation over input data
f = figure;
f.Position = [100 100 960 540];
hold on
grid on
title('Step response of model and real system', 'FontWeight','Normal')
xlabel('Time [min]')
ylabel('Percent [%]')
ylim([0,100])
plot(y);
plot(lsim(idtf.SysCT,u,t)+50)

%% Open control scheme
% Set Flexy2 parameters
calibrate = 0;
Port = a.ComPort;
close(a)

open_system('imc_flexy.slx');
