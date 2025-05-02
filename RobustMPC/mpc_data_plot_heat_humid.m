%%
clc, clear, close all
%%
run('C:\Users\Mirka\Documents\MATLAB\tbxmanager\toolboxes\vesna\R20240424\all\vesna_code\vesna_credentials_json.m'); % AFTER installing VESNA toolbox, change user name (Mirka in this case) in the path.
MyVesna = vesna;
MyVesna.connect(url, login, password)
%% Humidity Q = 1, Qi = 0.01, R = 150 and w = 30, Heat Q = 1000, Qi = 1000, R = 15 and w = 26, 25.04.2024
data = MyVesna.download(["humidity",65,"2024-04-25 13:33:55", "2024-04-25 14:23:00"],["humidiser",65,"2024-04-25 13:33:55", "2024-04-25 14:23:00"],["temperature",65,"2024-04-25 13:34:00", "2024-04-25 14:23:00"],["heater",65,"2024-04-25 13:33:00", "2024-04-25 14:24:00"]);
time = data.humidity.time;
t = 0:numel(time)-1;
hum = data.humidity.value;
T = data.temperature.value;
humidiser = data.humidiser.value;
heater = data.heater.value;
w_humid = 30;
w_heat = 26;
u_max_humid = 25;
u_min_humid = 0;
u_max_heat = 100;
u_min_heat = 0;

figure
sgtitle('Humidity and Temperature Control', 'FontSize', 20, 'Interpreter','latex')
subplot(2, 1, 1), grid on, box on
title('Humidity with Q$_{\mathrm{x}}$ = 1, Q$_{\mathrm{i}}$ = 0.01, R = 150', 'Interpreter','latex')
stairs(t, hum, 'b', LineWidth=2)
hold on
stairs(t, w_humid*ones(length(t), 1), '--r', LineWidth=2)
xlabel('Time [min]', 'interpreter', 'latex')
ylabel('Humidity [\%]', 'Interpreter','latex')
xlim([t(1) t(end)])
ylim([hum(1)-2 w_humid+2])
set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 15)
legend('Hum', 'w', 'Interpreter', 'latex', 'FontSize', 15, 'Location', 'best')
subplot(2, 1, 2), grid on, box on, hold on
stairs(t, humidiser, 'k', LineWidth=2)
stairs(t, u_min_humid*ones(length(t),1), '--m', LineWidth=2)
stairs(t, u_max_humid*ones(length(t),1), '-m', LineWidth=2)
xlabel('Time [min]', 'interpreter', 'latex')
ylabel('Humidiser [\%]', 'Interpreter','latex')
legend('u', 'u$_{\mathrm{min}}$', 'u$_{\mathrm{max}}$', 'Interpreter', 'latex', 'FontSize', 15, 'Location', 'northeast')
xlim([t(1) t(end)])
ylim([u_min_humid u_max_humid])
set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 15)
f2p('hum_mimo_control_25_04_24', 'LineWidth', 2, 'Ysplit', 5, 'Xsplit', 9)
% f2p('hum_mimo_control_25_04_24', 'LineWidth', 2, 'Ysplit', 5, 'Xsplit', 9, 'extension', 'pdf')
%%
figure
sgtitle('Humidity and Temperature Control', 'FontSize', 20, 'Interpreter','latex')
subplot(2, 1, 1), grid on, box on
title('Temperature with Q$_{\mathrm{x}}$ = 1000, Q$_{\mathrm{i}}$ = 1000, R = 15', 'Interpreter','latex')
stairs(t, T, 'b', LineWidth=2)
hold on
stairs(t, w_heat*ones(length(t), 1), '--r', LineWidth=2)
stairs(t, 25.5*ones(length(t),1), '--', LineWidth=2)
stairs(t, 26.5*ones(length(t),1), '--', LineWidth=2)
xlabel('Time [min]', 'interpreter', 'latex')
ylabel('T [$^\circ \mathrm{C}$]', 'Interpreter','latex')
xlim([t(1) t(end)])
ylim([T(1)-1 w_heat+1])
set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 15)
legend('T', 'w', '-$\delta$', '+$\delta$', 'Interpreter', 'latex', 'FontSize', 15, 'Location', 'best')
subplot(2, 1, 2), grid on, box on, hold on
stairs(t, heater, 'k', LineWidth=2)
stairs(t, u_min_heat*ones(length(t),1), '--m', LineWidth=2)
stairs(t, u_max_heat*ones(length(t),1), '-m', LineWidth=2)
xlabel('Time [min]', 'interpreter', 'latex')
ylabel('Heater [\%]', 'Interpreter','latex')
legend('u', 'u$_{\mathrm{min}}$', 'u$_{\mathrm{max}}$', 'Interpreter', 'latex', 'FontSize', 15, 'Location', 'northeast')
xlim([t(1) t(end)])
ylim([u_min_heat u_max_heat])
set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 15)
f2p('temp_mimo_control_25_04_24', 'LineWidth', 2, 'Ysplit', 5, 'Xsplit', 9)
% f2p('temp_mimo_control_25_04_24', 'LineWidth', 2, 'Ysplit', 5, 'Xsplit', 9, 'extension', 'png')
%%
figure
sgtitle('Humidity and Temperature Control', 'FontSize', 20, 'Interpreter','latex')
subplot(2, 1, 1), grid on, box on
title('Temperature with Q$_{\mathrm{x}}$ = 1000, Q$_{\mathrm{i}}$ = 1000, R = 15', 'Interpreter','latex')
stairs(t, T, 'r', LineWidth=2)
hold on
stairs(t, w_heat*ones(length(t), 1), '--b', LineWidth=2)
stairs(t, 25.5*ones(length(t),1), '--', LineWidth=2)
stairs(t, 26.5*ones(length(t),1), '-- ', LineWidth=2) 
xlabel('Time [min]', 'interpreter', 'latex')
ylabel('T [$^\circ \mathrm{C}$]', 'Interpreter','latex')
xlim([t(1) t(end)])
ylim([T(1)-1 w_heat+1])
set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 15)
legend('T', 'w', '-$\delta$', '+$\delta$', 'Interpreter', 'latex', 'FontSize', 15, 'Location', 'best')
subplot(2, 1, 2), grid on, box on
title('Humidity with Q$_{\mathrm{x}}$ = 1, Q$_{\mathrm{i}}$ = 0.01, R = 150', 'Interpreter','latex')
stairs(t, hum, 'b', LineWidth=2)
hold on
stairs(t, w_humid*ones(length(t), 1), '--r', LineWidth=2)
xlabel('Time [min]', 'interpreter', 'latex')
ylabel('Humidity [\%]', 'Interpreter','latex')
xlim([t(1) t(end)])
ylim([23 w_humid+2])
set(gca, 'TickLabelInterpreter', 'latex', 'FontSize', 15)
legend('Hum', 'w', 'Interpreter', 'latex', 'FontSize', 15, 'Location', 'best')
f2p('hum_temp_control_25_04_24', 'LineWidth', 2, 'Ysplit', 3, 'Xsplit', 9)
% f2p('hum_temp_control_25_04_24', 'LineWidth', 2, 'Ysplit', 3, 'Xsplit', 9, 'extension', 'png')
%%
load('mpc_data_log_heat.mat')

mpc_data_table_heat;
t_heat = mpc_data_table_heat.Time;
T = mpc_data_table_heat.t_val;
u_heater = mpc_data_table_heat.u_heater;
w_heat = mpc_data_table_heat.w_heat; 

w_temp = 27; 
w_night = 27; 

load('mpc_data_log_humid.mat')

mpc_data_table_humid;
t_humid = mpc_data_table_humid.Time;
h = mpc_data_table_humid.hum_val;
u_humid = mpc_data_table_humid.u_humid;
w_humid = mpc_data_table_humid.w_humid; 

w_hum = 32; 
w_night = 27; 

set(0, 'DefaultLineLineWidth', 2)
set(groot, ['Default', 'Stair', 'LineWidth'], 2)
%% 6.11.2024 
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 11; 
    day = 06;
%   idx = find(w == 27);
    t_index = find(t_heat.Year == year & t_heat.Month == month & t_heat.Day == day & w_heat == 27);
    stairs([0:numel(t_index)-1], w_heat(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-2])
    ylim([w_temp-2 w_temp+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_heater(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-2])
    ylim([0 100])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
f2p('06_11_24_heat', 'linewidth', 2)
% f2p('06_11_24_heat', 'linewidth', 2, 'extension', 'pdf')
%
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 11; 
    day = 06;
%   idx = find(w == 27);
    t_index = find(t_humid.Year == year & t_humid.Month == month & t_humid.Day == day & w_humid == 32);
    stairs([0:numel(t_index)-1], w_humid(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], h(t_index))
    xlim([0 numel(t_index)-2])
    ylim([w_hum-6 w_hum+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$h [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$h$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_humid(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 25*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-2])
    ylim([0 30])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
f2p('06_11_24_humid', 'linewidth', 2)
% f2p('06_11_24_humid', 'linewidth', 2, 'extension', 'pdf')
%%
load('mpc_data_log_heat.mat')

mpc_data_table_heat;
t_heat = mpc_data_table_heat.Time;
T = mpc_data_table_heat.t_val;
u_heater = mpc_data_table_heat.u_heater;
w_heat = mpc_data_table_heat.w_heat; 

w_temp = 28; 
w_night = 27; 

load('mpc_data_log_humid.mat')

mpc_data_table_humid;
t_humid = mpc_data_table_humid.Time;
h = mpc_data_table_humid.hum_val;
u_humid = mpc_data_table_humid.u_humid;
w_humid = mpc_data_table_humid.w_humid; 

w_hum = 31; 
w_night = 27; 

set(0, 'DefaultLineLineWidth', 2)
set(groot, ['Default', 'Stair', 'LineWidth'], 2)
%% 6.11.2024 - second try
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 11; 
    day = 06;
%   idx = find(w == 27);
    t_index = find(t_heat.Year == year & t_heat.Month == month & t_heat.Day == day & w_heat == 28);
    stairs([0:numel(t_index)-1], w_heat(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-3])
    ylim([w_temp-2 w_temp+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_heater(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-3])
    ylim([0 100])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
f2p('06_11_24_heat_2', 'linewidth', 2)
% f2p('06_11_24_heat_2', 'linewidth', 2, 'extension', 'pdf')
%
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 11; 
    day = 06;
%   idx = find(w == 27);
    t_index = find(t_humid.Year == year & t_humid.Month == month & t_humid.Day == day & w_humid == 31);
    stairs([0:numel(t_index)-1], w_humid(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], h(t_index))
    xlim([0 numel(t_index)-3])
    ylim([w_hum-6 w_hum+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$h [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$h$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_humid(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 25*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-3])
    ylim([0 30])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
f2p('06_11_24_humid_2', 'linewidth', 2)
% f2p('06_11_24_humid_2', 'linewidth', 2, 'extension', 'pdf')
%%
load('mpc_data_log_heat.mat')

mpc_data_table_heat;
t_heat = mpc_data_table_heat.Time;
T = mpc_data_table_heat.t_val;
u_heater = mpc_data_table_heat.u_heater;
w_heat = mpc_data_table_heat.w_heat; 

w_temp = 29; 

load('mpc_data_log_humid.mat')

mpc_data_table_humid;
t_humid = mpc_data_table_humid.Time;
h = mpc_data_table_humid.hum_val;
u_humid = mpc_data_table_humid.u_humid;
w_humid = mpc_data_table_humid.w_humid; 

w_hum = 26; 

set(0, 'DefaultLineLineWidth', 2)
set(groot, ['Default', 'Stair', 'LineWidth'], 2)
%% 12.11.2024
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 11; 
    day = 12;
%   idx = find(w == 27);
    t_index = find(t_heat.Year == year & t_heat.Month == month & t_heat.Day == day & w_heat == 29);
    t_index = t_index(8:end);
    stairs([0:numel(t_index)-1], w_heat(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_temp-2 w_temp+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_heater(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([0 100])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
% f2p('12_11_24_heat', 'linewidth', 2)
f2p('12_11_24_heat', 'linewidth', 2, 'extension', 'pdf', 'Xsplit', 9)
%
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 11; 
    day = 12;
%   idx = find(w == 27);
    t_index = find(t_humid.Year == year & t_humid.Month == month & t_humid.Day == day & w_humid == 26);
    t_index = t_index(8:end);
    stairs([0:numel(t_index)-1], w_humid(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], h(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_hum-6 w_hum+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$h [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$h$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_humid(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 25*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([0 30])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
% f2p('12_11_24_humid', 'linewidth', 2)
f2p('12_11_24_humid', 'linewidth', 2, 'extension', 'pdf', 'Xsplit', 9)
%%
load('mpc_data_log_heat.mat')

mpc_data_table_heat;
t_heat = mpc_data_table_heat.Time;
T = mpc_data_table_heat.t_val;
u_heater = mpc_data_table_heat.u_heater;
w_heat = mpc_data_table_heat.w_heat; 

w_temp = 27; 

load('mpc_data_log_humid.mat')

mpc_data_table_humid;
t_humid = mpc_data_table_humid.Time;
h = mpc_data_table_humid.hum_val;
u_humid = mpc_data_table_humid.u_humid;
w_humid = mpc_data_table_humid.w_humid; 

w_hum = 30; 

set(0, 'DefaultLineLineWidth', 2)
set(groot, ['Default', 'Stair', 'LineWidth'], 2)
%% 12.11.2024
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 11; 
    day = 13;
%   idx = find(w == 27);
    t_index = find(t_heat.Year == year & t_heat.Month == month & t_heat.Day == day & w_heat == 27);
    t_index = t_index(1:end-1);
    stairs([0:numel(t_index)-1], w_heat(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_temp-2 w_temp+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_heater(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([0 100])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
f2p('13_11_24_heat', 'linewidth', 2, 'Xsplit', 4)
% f2p('13_11_24_heat', 'linewidth', 2, 'extension', 'pdf', 'Xsplit', 4)
%
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 11; 
    day = 13;
%   idx = find(w == 27);
    t_index = find(t_humid.Year == year & t_humid.Month == month & t_humid.Day == day & w_humid == 30);
    t_index = t_index(1:end-1);
    stairs([0:numel(t_index)-1], w_humid(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], h(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_hum-6 w_hum+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$h [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$h$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_humid(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 25*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([0 30])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
f2p('13_11_24_humid', 'linewidth', 2, 'Xsplit', 4)
% f2p('13_11_24_humid', 'linewidth', 2, 'extension', 'pdf', 'Xsplit', 4)
%%
load('mpc_data_log_heat.mat')

mpc_data_table_heat;
t_heat = mpc_data_table_heat.Time;
T = mpc_data_table_heat.t_val;
u_heater = mpc_data_table_heat.u_heater;
w_heat = mpc_data_table_heat.w_heat; 

w_temp = 28; 

load('mpc_data_log_humid.mat')

mpc_data_table_humid;
t_humid = mpc_data_table_humid.Time;
h = mpc_data_table_humid.hum_val;
u_humid = mpc_data_table_humid.u_humid;
w_humid = mpc_data_table_humid.w_humid; 

w_hum = 29; 

set(0, 'DefaultLineLineWidth', 2)
set(groot, ['Default', 'Stair', 'LineWidth'], 2)
%% 13.11.2024
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 11; 
    day = 13;
%   idx = find(w == 27);
    t_index = find(t_heat.Year == year & t_heat.Month == month & t_heat.Day == day & w_heat == 28);
    % t_index = t_index(1:end-1);
    stairs([0:numel(t_index)-1], w_heat(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_temp-2 w_temp+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_heater(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([0 100])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
f2p('13_11_24_heat2', 'linewidth', 2, 'Xsplit', 9, 'Ysplit', 4)
% f2p('13_11_24_heat2', 'linewidth', 2, 'extension', 'pdf', 'Xsplit', 9, 'Ysplit', 4)

figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 11; 
    day = 13;
%   idx = find(w == 27);
    t_index = find(t_humid.Year == year & t_humid.Month == month & t_humid.Day == day & w_humid == 29);
    % t_index = t_index(1:end-1);
    stairs([0:numel(t_index)-1], w_humid(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], h(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_hum-6 w_hum+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$h [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$h$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_humid(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 25*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([0 30])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
f2p('13_11_24_humid2', 'linewidth', 2, 'Xsplit', 9)
% f2p('13_11_24_humid2', 'linewidth', 2, 'extension', 'pdf', 'Xsplit', 9)
%%
load('mpc_data_log_heat.mat')

mpc_data_table_heat;
t_heat = mpc_data_table_heat.Time;
T = mpc_data_table_heat.t_val;
u_heater = mpc_data_table_heat.u_heater;
w_heat = mpc_data_table_heat.w_heat; 

w_temp = 29; 

load('mpc_data_log_humid.mat')

mpc_data_table_humid;
t_humid = mpc_data_table_humid.Time;
h = mpc_data_table_humid.hum_val;
u_humid = mpc_data_table_humid.u_humid;
w_humid = mpc_data_table_humid.w_humid; 

w_hum = 26; 

set(0, 'DefaultLineLineWidth', 2)
set(groot, ['Default', 'Stair', 'LineWidth'], 2)
%% 26.11.2024
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 11; 
    day = 26;
%   idx = find(w == 27);
    t_index = find(t_heat.Year == year & t_heat.Month == month & t_heat.Day == day & w_heat == 29);
    t_index = t_index(55:end);
    stairs([0:numel(t_index)-1], w_heat(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_temp-2 w_temp+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_heater(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([0 100])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
f2p('26_11_24_heat2', 'linewidth', 2, 'Xsplit', 7, 'Ysplit', 4)
% f2p('26_11_24_heat2', 'linewidth', 2, 'extension', 'pdf', 'Xsplit', 7, 'Ysplit', 4)

figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 11; 
    day = 26;
%   idx = find(w == 27);
    t_index = find(t_humid.Year == year & t_humid.Month == month & t_humid.Day == day & w_humid == 26);
    t_index = t_index(9:end);
    stairs([0:numel(t_index)-1], w_humid(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], h(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_hum-6 w_hum+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$h [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$h$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_humid(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 25*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([0 30])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
f2p('26_11_24_humid2', 'linewidth', 2, 'Xsplit', 7)
% f2p('26_11_24_humid2', 'linewidth', 2, 'extension', 'pdf', 'Xsplit', 7)
%%
load('mpc_data_log_heat.mat')

mpc_data_table_heat;
t_heat = mpc_data_table_heat.Time;
T = mpc_data_table_heat.t_val;
u_heater = mpc_data_table_heat.u_heater;
w_heat = mpc_data_table_heat.w_heat; 

w_temp = 29; 

load('mpc_data_log_humid.mat')

mpc_data_table_humid;
t_humid = mpc_data_table_humid.Time;
h = mpc_data_table_humid.hum_val;
u_humid = mpc_data_table_humid.u_humid;
w_humid = mpc_data_table_humid.w_humid; 

w_hum = 25; 

set(0, 'DefaultLineLineWidth', 2)
set(groot, ['Default', 'Stair', 'LineWidth'], 2)
%% 26.11.2024
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 11; 
    day = 26;
%   idx = find(w == 27);
    t_index = find(t_heat.Year == year & t_heat.Month == month & t_heat.Day == day & w_heat == 29);
    t_index = t_index(127:end-2);
    stairs([0:numel(t_index)-1], w_heat(t_index), 'k--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_temp-2 w_temp+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$r_{\mathrm{T}}$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 15, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid on
    stairs([0:numel(t_index)-1], u_heater(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'k--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'k-.')
    xlim([0 numel(t_index)-1])
    ylim([0 100])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u_{\mathrm{heat}} \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u_\mathrm{heat}$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 15, 'Location', 'southeast')
    set(leg1, 'Orientation', 'vertical')
    % xticks([0 10 20 30 40 50])
f2p('26_11_24_heat3', 'linewidth', 2, 'Ysplit', 4)
% f2p('26_11_24_heat3', 'linewidth', 2, 'extension', 'pdf', 'Ysplit', 4)

figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 11; 
    day = 26;
%   idx = find(w == 27);
    t_index = find(t_humid.Year == year & t_humid.Month == month & t_humid.Day == day & w_humid == 25);
    t_index = t_index(4:end-2);
    stairs([0:numel(t_index)-1], w_humid(t_index), 'k--')
 
    stairs([0:numel(t_index)-1], h(t_index))
    plot([0:numel(t_index)-1], 24*ones(1, numel(t_index)), ':', 'Color', [0.3529, 0.3529, 0.3529])
    plot([0:numel(t_index)-1], 26*ones(1, numel(t_index)), ':', 'Color', [0.3529, 0.3529, 0.3529])
    xlim([0 numel(t_index)-1])
    ylim([w_hum-3 w_hum+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$h [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$r_{\mathrm{h}}$', '$h$', '$\pm \delta$', 'interpreter', 'latex');
    set(leg, 'FontSize', 15, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid on
    stairs([0:numel(t_index)-1], u_humid(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'k--')
    plot([0:numel(t_index)-1], 25*ones(1, numel(t_index)), 'k-.')
    xlim([0 numel(t_index)-1])
    ylim([0 30])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u_{\mathrm{humid}} \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u_{\mathrm{humid}}$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 15, 'Location', 'southeast')
    set(leg1, 'Orientation', 'vertical')
    % xticks([0 10 20 30 40 50])
f2p('26_11_24_humid3', 'linewidth', 2, 'Xsplit', 11)
% f2p('26_11_24_humid3', 'linewidth', 2, 'extension', 'pdf', 'Xsplit', 11)

%TEMPERATURE
t_index = find(t_heat.Year == year & t_heat.Month == month & t_heat.Day == day & w_heat == 29);
t_index = t_index(127:end-2);
ISE = 0;
x = T(t_index);
y = w_temp;
for i = [1:55]
    err = (x(i) - y)^2;
    ISE = ISE + err;
end
ISE_26_11_3 = ISE; % Ts = 1 min.

z = u_heater(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO = 0;
for i = [1:55]
    err = (z(i) - zz(i))^2;
    SSO = SSO + err;
end
SSO_26_11_3 = SSO; % Ts = 1 min.

NSSO_26_11_3 = ISE/10 + SSO/100000;

uu = u_heater(t_index)/100;
E_J = 0;
for i = [1:55]
    vykon = 60*40*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J = E_J + vykon; % Joules
end
E_kJ_26_11_3 = E_J/1000 % Kilojoules

E_kWh_26_11_3 = E_kJ_26_11_3/(3.6*10^3);
mCO2_26_11_3 = E_kWh_26_11_3*335

%HUMIDITY
t_index = find(t_humid.Year == year & t_humid.Month == month & t_humid.Day == day & w_humid == 25);
t_index = t_index(4:end-2);
ISE = 0;
x = T(t_index);
y = w_hum;
for i = [1:55]
    err = (x(i) - y)^2;
    ISE = ISE + err;
end
ISE_hum_26_11_3 = ISE; % Ts = 1 min.

z = u_humid(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO = 0;
for i = [1:55]
    err = (z(i) - zz(i))^2;
    SSO = SSO + err;
end
SSO_hum_26_11_3 = SSO; % Ts = 1 min.

NSSO_hum_26_11_3 = ISE/10 + SSO/100000;

uu = u_humid(t_index)/25;
E_J = 0;
for i = [1:55]
    vykon = 60*5.4*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J = E_J + vykon; % Joules
end
E_kJ_hum_26_11_3 = E_J/1000 % Kilojoules

E_kWh_hum_26_11_3 = E_kJ_hum_26_11_3/(3.6*10^3);
mCO2_hum_26_11_3 = E_kWh_hum_26_11_3*335;
%%
load('mpc_data_log_heat.mat')

mpc_data_table_heat;
t_heat = mpc_data_table_heat.Time;
T = mpc_data_table_heat.t_val;
u_heater = mpc_data_table_heat.u_heater;
w_heat = mpc_data_table_heat.w_heat; 

w_temp = 29; 

load('mpc_data_log_humid.mat')

mpc_data_table_humid;
t_humid = mpc_data_table_humid.Time;
h = mpc_data_table_humid.hum_val;
u_humid = mpc_data_table_humid.u_humid;
w_humid = mpc_data_table_humid.w_humid; 

w_hum = 27; 

set(0, 'DefaultLineLineWidth', 2)
set(groot, ['Default', 'Stair', 'LineWidth'], 2)
%% 2.12.2024
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 12; 
    day = 2;
%   idx = find(w == 27);
    t_index = find(t_heat.Year == year & t_heat.Month == month & t_heat.Day == day & w_heat == 29);
    % t_index = t_index(127:end-1);
    stairs([0:numel(t_index)-1], w_heat(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_temp-3 w_temp+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_heater(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([0 100])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
f2p('2_12_24_heat', 'linewidth', 2, 'Xsplit', 7, 'Ysplit', 4)
% f2p('2_12_24_heat', 'linewidth', 2, 'extension', 'pdf', 'Xsplit', 7, 'Ysplit', 4)

figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 12; 
    day = 2;
%   idx = find(w == 27);
    t_index = find(t_humid.Year == year & t_humid.Month == month & t_humid.Day == day & w_humid == 27);
    % t_index = t_index(4:end-1);
    stairs([0:numel(t_index)-1], w_humid(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], h(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_hum-6 w_hum+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$h [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$h$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_humid(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 25*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([0 30])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
f2p('2_12_24_humid', 'linewidth', 2, 'Xsplit', 7)
% f2p('2_12_24_humid', 'linewidth', 2, 'extension', 'pdf', 'Xsplit', 7)
%%
load('mpc_data_log_heat.mat')

mpc_data_table_heat;
t_heat = mpc_data_table_heat.Time;
T = mpc_data_table_heat.t_val;
u_heater = mpc_data_table_heat.u_heater;
w_heat = mpc_data_table_heat.w_heat; 

w_temp = 29; 

load('mpc_data_log_humid.mat')

mpc_data_table_humid;
t_humid = mpc_data_table_humid.Time;
h = mpc_data_table_humid.hum_val;
u_humid = mpc_data_table_humid.u_humid;
w_humid = mpc_data_table_humid.w_humid; 

w_hum = 25; 

set(0, 'DefaultLineLineWidth', 2)
set(groot, ['Default', 'Stair', 'LineWidth'], 2)
%% 3.12.2024
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 12; 
    day = 3;
%   idx = find(w == 27);
    t_index = find(t_heat.Year == year & t_heat.Month == month & t_heat.Day == day & w_heat == 29);
    t_index = t_index(1:56);
    stairs([0:numel(t_index)-1], w_heat(t_index), 'k--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_temp-3 w_temp+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$r_{\mathrm{T}}$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 15, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid on
    stairs([0:numel(t_index)-1], u_heater(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'k--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'k-.')
    xlim([0 numel(t_index)-1])
    ylim([0 100])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u_{\mathrm{heat}} \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u_{\mathrm{heat}}$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 15, 'Location', 'southeast')
    set(leg1, 'Orientation', 'vertical')
f2p('3_12_24_heat', 'linewidth', 2, 'Ysplit', 4)
% f2p('3_12_24_heat', 'linewidth', 2, 'extension', 'pdf', 'Ysplit', 4)

figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 12; 
    day = 3;
%   idx = find(w == 27);
    t_index = find(t_humid.Year == year & t_humid.Month == month & t_humid.Day == day & w_humid == 25);
    t_index = t_index(1:56);
    stairs([0:numel(t_index)-1], w_humid(t_index), 'k--')
 
    stairs([0:numel(t_index)-1], h(t_index))
    plot([0:numel(t_index)-1], 24*ones(1, numel(t_index)), ':', 'Color', [0.3529, 0.3529, 0.3529])
    plot([0:numel(t_index)-1], 26*ones(1, numel(t_index)), ':', 'Color', [0.3529, 0.3529, 0.3529])
    xlim([0 numel(t_index)-1])
    ylim([w_hum-3 w_hum+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$h [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$r_{\mathrm{h}}$', '$h$', '$\pm \delta$', 'interpreter', 'latex');
    set(leg, 'FontSize', 15, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_humid(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'k--')
    plot([0:numel(t_index)-1], 25*ones(1, numel(t_index)), 'k-.')
    xlim([0 numel(t_index)-1])
    ylim([0 30])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u_{\mathrm{humid}} \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u_{\mathrm{humid}}$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 15, 'Location', 'southeast')
    set(leg1, 'Orientation', 'vertical')
f2p('3_12_24_humid', 'linewidth', 2)
% f2p('3_12_24_humid', 'linewidth', 2, 'extension', 'pdf', 'Xsplit', 11)

%TEMPERATURE
t_index = find(t_heat.Year == year & t_heat.Month == month & t_heat.Day == day & w_heat == 29);
t_index = t_index(1:56);
ISE = 0;
x = T(t_index);
y = w_temp;
for i = [1:55]
    err = (x(i) - y)^2;
    ISE = ISE + err;
end
ISE_3_12_1 = ISE; % Ts = 1 min.

z = u_heater(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO = 0;
for i = [1:55]
    err = (z(i) - zz(i))^2;
    SSO = SSO + err;
end
SSO_3_12_1 = SSO; % Ts = 1 min.

NSSO_3_12_1 = ISE/10 + SSO/100000;

uu = u_heater(t_index)/100;
E_J = 0;
for i = [1:55]
    vykon = 60*40*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J = E_J + vykon; % Joules
end
E_kJ_3_12_1 = E_J/1000 % Kilojoules

E_kWh_3_12_1 = E_kJ_3_12_1/(3.6*10^3);
mCO2_3_12_1 = E_kWh_3_12_1*331

%HUMIDITY
t_index = find(t_humid.Year == year & t_humid.Month == month & t_humid.Day == day & w_humid == 25);
t_index = t_index(1:56);
ISE = 0;
x = T(t_index);
y = w_hum;
for i = [1:55]
    err = (x(i) - y)^2;
    ISE = ISE + err;
end
ISE_hum_3_12_1 = ISE; % Ts = 1 min.

z = u_humid(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO = 0;
for i = [1:55]
    err = (z(i) - zz(i))^2;
    SSO = SSO + err;
end
SSO_hum_3_12_1 = SSO; % Ts = 1 min.

NSSO_hum_3_12_1 = ISE/10 + SSO/100000;

uu = u_humid(t_index)/25;
E_J = 0;
for i = [1:55]
    vykon = 60*5.4*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J = E_J + vykon; % Joules
end
E_kJ_hum_3_12_1 = E_J/1000 % Kilojoules

E_kWh_hum_3_12_1 = E_kJ_hum_3_12_1/(3.6*10^3);
mCO2_hum_3_12_1 = E_kWh_hum_3_12_1*331
%%
load('mpc_data_log_heat.mat')

mpc_data_table_heat;
t_heat = mpc_data_table_heat.Time;
T = mpc_data_table_heat.t_val;
u_heater = mpc_data_table_heat.u_heater;
w_heat = mpc_data_table_heat.w_heat; 

w_temp = 29; 

load('mpc_data_log_humid.mat')

mpc_data_table_humid;
t_humid = mpc_data_table_humid.Time;
h = mpc_data_table_humid.hum_val;
u_humid = mpc_data_table_humid.u_humid;
w_humid = mpc_data_table_humid.w_humid; 

w_hum = 25; 

set(0, 'DefaultLineLineWidth', 2)
set(groot, ['Default', 'Stair', 'LineWidth'], 2)
%% 3.12.2024
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 12; 
    day = 3;
%   idx = find(w == 27);
    t_index = find(t_heat.Year == year & t_heat.Month == month & t_heat.Day == day & w_heat == 29);
    t_index = t_index(72:72+55);
    stairs([0:numel(t_index)-1], w_heat(t_index), 'k--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_temp-3 w_temp+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$r_{\mathrm{T}}$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 15, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_heater(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'k--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'k-.')
    xlim([0 numel(t_index)-1])
    ylim([0 100])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u_{\mathrm{heat}} \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend(['$u_{\mathrm{heat}}$'], '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 15, 'Location', 'southeast')
    set(leg1, 'Orientation', 'vertical')
f2p('3_12_24_heat2', 'linewidth', 2, 'Xsplit', 11, 'Ysplit', 4)
% f2p('3_12_24_heat2', 'linewidth', 2, 'extension', 'pdf', 'Xsplit', 11, 'Ysplit', 4)

figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 12; 
    day = 3;
%   idx = find(w == 27);
    t_index = find(t_humid.Year == year & t_humid.Month == month & t_humid.Day == day & w_humid == 25);
    t_index = t_index(72:72+55);
    stairs([0:numel(t_index)-1], w_humid(t_index), 'k--')
 
    stairs([0:numel(t_index)-1], h(t_index))
    plot([0:numel(t_index)-1], 24*ones(1, numel(t_index)), ':', 'Color', [0.3529, 0.3529, 0.3529])
    plot([0:numel(t_index)-1], 26*ones(1, numel(t_index)), ':', 'Color', [0.3529, 0.3529, 0.3529])    
    xlim([0 numel(t_index)-1])
    ylim([w_hum-3 w_hum+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$h [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$r_{\mathrm{h}}$', '$h$', '$\pm \delta$', 'interpreter', 'latex');
    set(leg, 'FontSize', 15, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_humid(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'k--')
    plot([0:numel(t_index)-1], 25*ones(1, numel(t_index)), 'k-.')
    xlim([0 numel(t_index)-1])
    ylim([0 30])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u_{\mathrm{humid}} \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u_{\mathrm{humid}}$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 15, 'Location', 'southeast')
    set(leg1, 'Orientation', 'vertical')
f2p('3_12_24_humid2', 'linewidth', 2, 'Xsplit', 11)
% f2p('3_12_24_humid2', 'linewidth', 2, 'extension', 'pdf', 'Xsplit', 11)

%TEMPERATURE
ISE = 0;
x = T(t_index);
y = w_temp;
for i = [1:55]
    err = (x(i) - y)^2;
    ISE = ISE + err;
end
ISE_3_12_2 = ISE; % Ts = 1 min.

z = u_heater(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO = 0;
for i = [1:55]
    err = (z(i) - zz(i))^2;
    SSO = SSO + err;
end
SSO_3_12_2 = SSO; % Ts = 1 min.

NSSO_3_12_2 = ISE/10 + SSO/100000;

uu = u_heater(t_index)/100;
E_J = 0;
for i = [1:55]
    vykon = 60*40*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J = E_J + vykon; % Joules
end
E_kJ_3_12_2 = E_J/1000 % Kilojoules

E_kWh_3_12_2 = E_kJ_3_12_2/(3.6*10^3);
mCO2_3_12_2 = E_kWh_3_12_2*331

%HUMIDITY
ISE = 0;
x = T(t_index);
y = w_hum;
for i = [1:55]
    err = (x(i) - y)^2;
    ISE = ISE + err;
end
ISE_hum_3_12_2 = ISE; % Ts = 1 min.

z = u_humid(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO = 0;
for i = [1:55]
    err = (z(i) - zz(i))^2;
    SSO = SSO + err;
end
SSO_hum_3_12_2 = SSO; % Ts = 1 min.

NSSO_hum_3_12_2 = ISE/10 + SSO/100000;

uu = u_humid(t_index)/25;
E_J = 0;
for i = [1:55]
    vykon = 60*5.4*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J = E_J + vykon; % Joules
end
E_kJ_hum_3_12_2 = E_J/1000 % Kilojoules

E_kWh_hum_3_12_2 = E_kJ_hum_3_12_2/(3.6*10^3);
mCO2_hum_3_12_2 = E_kWh_hum_3_12_2*331
%%
load('mpc_data_log_heat.mat')

mpc_data_table_heat;
t_heat = mpc_data_table_heat.Time;
T = mpc_data_table_heat.t_val;
u_heater = mpc_data_table_heat.u_heater;
w_heat = mpc_data_table_heat.w_heat; 

w_temp = 29; 

load('mpc_data_log_humid.mat')

mpc_data_table_humid;
t_humid = mpc_data_table_humid.Time;
h = mpc_data_table_humid.hum_val;
u_humid = mpc_data_table_humid.u_humid;
w_humid = mpc_data_table_humid.w_humid; 

w_hum = 25; 

set(0, 'DefaultLineLineWidth', 2)
set(groot, ['Default', 'Stair', 'LineWidth'], 2)
%% 3.12.2024_3
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 12; 
    day = 3;
%   idx = find(w == 27);
    t_index = find(t_heat.Year == year & t_heat.Month == month & t_heat.Day == day & w_heat == 29);
    t_index = t_index(144:end-11);
    stairs([0:numel(t_index)-1], w_heat(t_index), 'k--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_temp-3 w_temp+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$r_{\mathrm{T}}$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 15, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid on
    stairs([0:numel(t_index)-1], u_heater(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'k--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'k-.')
    xlim([0 numel(t_index)-1])
    ylim([0 100])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u_{\mathrm{heat}} \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u_{\mathrm{heat}}$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 15, 'Location', 'southeast')
    set(leg1, 'Orientation', 'vertical')
f2p('3_12_24_heat3', 'linewidth', 2, 'Xsplit', 11, 'Ysplit', 4)
% f2p('3_12_24_heat3', 'linewidth', 2, 'extension', 'pdf', 'Xsplit', 11, 'Ysplit', 4)

figure
 
subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 12; 
    day = 3;
%   idx = find(w == 27);
    t_index = find(t_humid.Year == year & t_humid.Month == month & t_humid.Day == day & w_humid == 25);
    t_index = t_index(144:end-11);
    stairs([0:numel(t_index)-1], w_humid(t_index), 'k--')
 
    stairs([0:numel(t_index)-1], h(t_index))
    plot([0:numel(t_index)-1], 24*ones(1, numel(t_index)), ':', 'Color', [0.3529, 0.3529, 0.3529])
    plot([0:numel(t_index)-1], 26*ones(1, numel(t_index)), ':', 'Color', [0.3529, 0.3529, 0.3529])
    xlim([0 numel(t_index)-1])
    ylim([w_hum-3 w_hum+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$h [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$r_{\mathrm{h}}$', '$h$', '$\pm \delta$', 'interpreter', 'latex');
    set(leg, 'FontSize', 15, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_humid(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'k--')
    plot([0:numel(t_index)-1], 25*ones(1, numel(t_index)), 'k-.')
    xlim([0 numel(t_index)-1])
    ylim([0 30])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u_{\mathrm{humid}} \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u_{\mathrm{humid}}$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 15, 'Location', 'southeast')
    set(leg1, 'Orientation', 'vertical')
f2p('3_12_24_humid3', 'linewidth', 2, 'Xsplit', 11)
% f2p('3_12_24_humid3', 'linewidth', 2, 'extension', 'pdf', 'Xsplit', 11)

%TEMPERATURE
ISE = 0;
x = T(t_index);
y = w_temp;
for i = [1:55]
    err = (x(i) - y)^2;
    ISE = ISE + err;
end
ISE_3_12_3 = ISE; % Ts = 1 min.

z = u_heater(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO = 0;
for i = [1:55]
    err = (z(i) - zz(i))^2;
    SSO = SSO + err;
end
SSO_3_12_3 = SSO; % Ts = 1 min.

NSSO_3_12_3 = ISE/10 + SSO/100000;

uu = u_heater(t_index)/100;
E_J = 0;
for i = [1:55]
    vykon = 60*40*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J = E_J + vykon; % Joules
end
E_kJ_3_12_3 = E_J/1000 % Kilojoules

E_kWh_3_12_3 = E_kJ_3_12_3/(3.6*10^3);
mCO2_3_12_3 = E_kWh_3_12_3*331

%HUMIDITY
ISE = 0;
x = T(t_index);
y = w_hum;
for i = [1:55]
    err = (x(i) - y)^2;
    ISE = ISE + err;
end
ISE_hum_3_12_3 = ISE; % Ts = 1 min.

z = u_humid(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO = 0;
for i = [1:55]
    err = (z(i) - zz(i))^2;
    SSO = SSO + err;
end
SSO_hum_3_12_3 = SSO; % Ts = 1 min.

NSSO_hum_3_12_3 = ISE/10 + SSO/100000;

uu = u_humid(t_index)/25;
E_J = 0;
for i = [1:55]
    vykon = 60*5.4*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J = E_J + vykon; % Joules
end
E_kJ_hum_3_12_3 = E_J/1000 % Kilojoules

E_kWh_hum_3_12_3 = E_kJ_hum_3_12_3/(3.6*10^3);
mCO2_hum_3_12_3 = E_kWh_hum_3_12_3*331
%%
load('mpc_data_log_heat.mat')

mpc_data_table_heat;
t_heat = mpc_data_table_heat.Time;
T = mpc_data_table_heat.t_val;
u_heater = mpc_data_table_heat.u_heater;
w_heat = mpc_data_table_heat.w_heat; 

w_temp = 29; 

load('mpc_data_log_humid.mat')

mpc_data_table_humid;
t_humid = mpc_data_table_humid.Time;
h = mpc_data_table_humid.hum_val;
u_humid = mpc_data_table_humid.u_humid;
w_humid = mpc_data_table_humid.w_humid; 

w_hum = 26; 

set(0, 'DefaultLineLineWidth', 2)
set(groot, ['Default', 'Stair', 'LineWidth'], 2)
%% 10.12.2024
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 12; 
    day = 10;
%   idx = find(w == 27);
    t_index = find(t_heat.Year == year & t_heat.Month == month & t_heat.Day == day & w_heat == 29);
    % t_index = t_index(144:end);
    stairs([0:numel(t_index)-1], w_heat(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_temp-3 w_temp+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_heater(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([0 100])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
f2p('10_12_24_heat', 'linewidth', 2, 'Xsplit', 6, 'Ysplit', 4)
% f2p('10_12_24_heat', 'linewidth', 2, 'extension', 'pdf', 'Xsplit', 6, 'Ysplit', 4)

figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 12; 
    day = 10;
%   idx = find(w == 27);
    t_index = find(t_humid.Year == year & t_humid.Month == month & t_humid.Day == day & w_humid == 26);
    % t_index = t_index(144:end);
    stairs([0:numel(t_index)-1], w_humid(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], h(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_hum-3 w_hum+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$h [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$h$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_humid(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 25*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([0 30])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
f2p('10_12_24_humid', 'linewidth', 2, 'Xsplit', 6)
% f2p('10_12_24_humid', 'linewidth', 2, 'extension', 'pdf', 'Xsplit', 6)
%%
load('mpc_data_log_heat.mat')

mpc_data_table_heat;
t_heat = mpc_data_table_heat.Time;
T = mpc_data_table_heat.t_val;
u_heater = mpc_data_table_heat.u_heater;
w_heat = mpc_data_table_heat.w_heat; 

w_temp = 29; 

load('mpc_data_log_humid.mat')

mpc_data_table_humid;
t_humid = mpc_data_table_humid.Time;
h = mpc_data_table_humid.hum_val;
u_humid = mpc_data_table_humid.u_humid;
w_humid = mpc_data_table_humid.w_humid; 

w_hum = 25; 

set(0, 'DefaultLineLineWidth', 2)
set(groot, ['Default', 'Stair', 'LineWidth'], 2)
%% 11.12.2024
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 12; 
    day = 11;
%   idx = find(w == 27);
    t_index = find(t_heat.Year == year & t_heat.Month == month & t_heat.Day == day & w_heat == 29);
    t_index = t_index(1:56);
    stairs([0:numel(t_index)-1], w_heat(t_index), 'k--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_temp-3 w_temp+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$r_{\mathrm{T}}$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 15, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid on
    stairs([0:numel(t_index)-1], u_heater(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'k--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'k-.')
    xlim([0 numel(t_index)-1])
    ylim([0 100])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u_{\mathrm{heat}} \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u_{\mathrm{heat}}$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 15, 'Location', 'southeast')
    set(leg1, 'Orientation', 'vertical')
f2p('11_12_24_heat', 'linewidth', 2, 'Xsplit', 11, 'Ysplit', 4)
% f2p('11_12_24_heat', 'linewidth', 2, 'extension', 'pdf', 'Xsplit', 11, 'Ysplit', 4)

figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 12; 
    day = 11;
%   idx = find(w == 27);
    t_index = find(t_humid.Year == year & t_humid.Month == month & t_humid.Day == day & w_humid == 25);
    t_index = t_index(1:56);
    stairs([0:numel(t_index)-1], w_humid(t_index), 'k--')
 
    stairs([0:numel(t_index)-1], h(t_index))
    plot([0:numel(t_index)-1], 24*ones(1, numel(t_index)), ':', 'Color', [0.3529, 0.3529, 0.3529])
    plot([0:numel(t_index)-1], 26*ones(1, numel(t_index)), ':', 'Color', [0.3529, 0.3529, 0.3529])
    xlim([0 numel(t_index)-1])
    ylim([w_hum-3 w_hum+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$h [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$r_{\mathrm{h}}$', '$h$', '$\pm \delta$', 'interpreter', 'latex');
    set(leg, 'FontSize', 15, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid on
    stairs([0:numel(t_index)-1], u_humid(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'k--')
    plot([0:numel(t_index)-1], 25*ones(1, numel(t_index)), 'k-.')
    xlim([0 numel(t_index)-1])
    ylim([0 30])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u_{\mathrm{humid}} \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u_{\mathrm{humid}}$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 15, 'Location', 'southeast')
    set(leg1, 'Orientation', 'vertical')
f2p('11_12_24_humid', 'linewidth', 2, 'Xsplit', 11)
% f2p('11_12_24_humid', 'linewidth', 2, 'extension', 'pdf', 'Xsplit', 11)

%TEMPERATURE
ISE = 0;
x = T(t_index);
y = w_temp;
for i = [1:55]
    err = (x(i) - y)^2;
    ISE = ISE + err;
end
ISE_11_12 = ISE; % Ts = 1 min.

z = u_heater(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO = 0;
for i = [1:55]
    err = (z(i) - zz(i))^2;
    SSO = SSO + err;
end
SSO_11_12 = SSO; % Ts = 1 min.

NSSO_11_12 = ISE/10 + SSO/100000;

uu = u_heater(t_index)/100;
E_J = 0;
for i = [1:55]
    vykon = 60*40*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J = E_J + vykon; % Joules
end
E_kJ_11_12 = E_J/1000 % Kilojoules

E_kWh_11_12 = E_kJ_11_12/(3.6*10^3);
mCO2_11_12 = E_kWh_11_12*331

%HUMIDITY
ISE = 0;
x = T(t_index);
y = w_hum;
for i = [1:55]
    err = (x(i) - y)^2;
    ISE = ISE + err;
end
ISE_hum_11_12 = ISE; % Ts = 1 min.

z = u_humid(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO = 0;
for i = [1:55]
    err = (z(i) - zz(i))^2;
    SSO = SSO + err;
end
SSO_hum_11_12 = SSO; % Ts = 1 min.

NSSO_hum_11_12 = ISE/10 + SSO/100000;

uu = u_humid(t_index)/25;
E_J = 0;
for i = [1:55]
    vykon = 60*5.4*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J = E_J + vykon; % Joules
end
E_kJ_hum_11_12 = E_J/1000 % Kilojoules

E_kWh_hum_11_12 = E_kJ_hum_11_12/(3.6*10^3);
mCO2_hum_11_12 = E_kWh_hum_11_12*331
%%
load('mpc_data_log_heat.mat')

mpc_data_table_heat;
t_heat = mpc_data_table_heat.Time;
T = mpc_data_table_heat.t_val;
u_heater = mpc_data_table_heat.u_heater;
w_heat = mpc_data_table_heat.w_heat; 

w_temp = 29; 

load('mpc_data_log_humid.mat')

mpc_data_table_humid;
t_humid = mpc_data_table_humid.Time;
h = mpc_data_table_humid.hum_val;
u_humid = mpc_data_table_humid.u_humid;
w_humid = mpc_data_table_humid.w_humid; 

w_hum = 24; 

set(0, 'DefaultLineLineWidth', 2)
set(groot, ['Default', 'Stair', 'LineWidth'], 2)
%% 16.12.2024
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 12; 
    day = 16;
%   idx = find(w == 27);
    t_index = find(t_heat.Year == year & t_heat.Month == month & t_heat.Day == day & w_heat == 29);
    t_index = t_index(1:end-1);
    stairs([0:numel(t_index)-1], w_heat(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_temp-3 w_temp+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_heater(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([0 100])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
f2p('16_12_24_heat', 'linewidth', 2, 'Xsplit', 9, 'Ysplit', 4)
% f2p('16_12_24_heat', 'linewidth', 2, 'extension', 'pdf', 'Xsplit', 9, 'Ysplit', 4)

figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 12; 
    day = 16;
%   idx = find(w == 27);
    t_index = find(t_humid.Year == year & t_humid.Month == month & t_humid.Day == day & w_humid == 24);
    t_index = t_index(1:end-1);
    stairs([0:numel(t_index)-1], w_humid(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], h(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_hum-3 w_hum+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$h [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$h$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_humid(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 25*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([0 30])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
f2p('16_12_24_humid', 'linewidth', 2, 'Xsplit', 9)
% f2p('16_12_24_humid', 'linewidth', 2, 'extension', 'pdf', 'Xsplit', 9)
%%
load('mpc_data_log_heat.mat')

mpc_data_table_heat;
t_heat = mpc_data_table_heat.Time;
T = mpc_data_table_heat.t_val;
u_heater = mpc_data_table_heat.u_heater;
w_heat = mpc_data_table_heat.w_heat; 

w_temp = 29; 

load('mpc_data_log_humid.mat')

mpc_data_table_humid;
t_humid = mpc_data_table_humid.Time;
h = mpc_data_table_humid.hum_val;
u_humid = mpc_data_table_humid.u_humid;
w_humid = mpc_data_table_humid.w_humid; 

w_hum = 24; 

set(0, 'DefaultLineLineWidth', 2)
set(groot, ['Default', 'Stair', 'LineWidth'], 2)
%% 16.12.2024 - second
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 12; 
    day = 16;
%   idx = find(w == 27);
    t_index = find(t_heat.Year == year & t_heat.Month == month & t_heat.Day == day & w_heat == 29);
    t_index = t_index(75:end-2);
    stairs([0:numel(t_index)-1], w_heat(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_temp-3 w_temp+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_heater(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([0 100])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
f2p('16_12_24_heat2', 'linewidth', 2, 'Ysplit', 4)
% f2p('16_12_24_heat2', 'linewidth', 2, 'extension', 'pdf', 'Ysplit', 4)

figure

subplot(2,1,1), hold on, box on, grid on
    year = 2024;
    month = 12; 
    day = 16;
%   idx = find(w == 27);
    t_index = find(t_humid.Year == year & t_humid.Month == month & t_humid.Day == day & w_humid == 24);
    t_index = t_index(75:end-2);
    stairs([0:numel(t_index)-1], w_humid(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], h(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_hum-3 w_hum+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$h [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$h$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_humid(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 25*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([0 30])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
f2p('16_12_24_humid2',  'linewidth', 2)
% f2p('16_12_24_humid2', 'linewidth', 2, 'extension', 'pdf')
%%
load('mpc_data_log_heat.mat')

mpc_data_table_heat;
t_heat = mpc_data_table_heat.Time;
T = mpc_data_table_heat.t_val;
u_heater = mpc_data_table_heat.u_heater;
w_heat = mpc_data_table_heat.w_heat; 

w_temp = 29; 

load('mpc_data_log_humid.mat')

mpc_data_table_humid;
t_humid = mpc_data_table_humid.Time;
h = mpc_data_table_humid.hum_val;
u_humid = mpc_data_table_humid.u_humid;
w_humid = mpc_data_table_humid.w_humid; 

w_hum = 24; 

set(0, 'DefaultLineLineWidth', 2)
set(groot, ['Default', 'Stair', 'LineWidth'], 2)
%%
load('mpc_data_log_heat.mat')

mpc_data_table_heat;
t_heat = mpc_data_table_heat.Time;
T = mpc_data_table_heat.t_val;
u_heater = mpc_data_table_heat.u_heater;
w_heat = mpc_data_table_heat.w_heat; 

w_temp = 29; 
w_night = 27; 

load('mpc_data_log_humid.mat')

mpc_data_table_humid;
t_humid = mpc_data_table_humid.Time;
h = mpc_data_table_humid.hum_val;
u_humid = mpc_data_table_humid.u_humid;
w_humid = mpc_data_table_humid.w_humid; 

w_hum = 30; 
w_night = 27; 

set(0, 'DefaultLineLineWidth', 2)
set(groot, ['Default', 'Stair', 'LineWidth'], 2)
%% 12.3.2025
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2025;
    month = 03; 
    day = 12;
%   idx = find(w == 27);
    t_index = find(t_heat.Year == year & t_heat.Month == month & t_heat.Day == day & w_heat == 29);
    t_index = t_index(1:46);
    stairs([0:numel(t_index)-1], w_heat(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_temp-3 w_temp+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_heater(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([0 100])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
f2p('12_03_25_heat', 'linewidth', 2, 'Ysplit', 4)
% f2p('12_03_25_heat', 'linewidth', 2, 'extension', 'pdf', 'Ysplit', 4)

figure

subplot(2,1,1), hold on, box on, grid on
    year = 2025;
    month = 03; 
    day = 12;
%   idx = find(w == 27);
    t_index = find(t_humid.Year == year & t_humid.Month == month & t_humid.Day == day & w_humid == 30);
    t_index = t_index(1:46);
    stairs([0:numel(t_index)-1], w_humid(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], h(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_hum-3 w_hum+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$h [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$h$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_humid(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 25*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([0 30])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
f2p('12_03_25_humid',  'linewidth', 2)
% f2p('12_03_25_humid', 'linewidth', 2, 'extension', 'pdf')
%%
load('mpc_data_log_heat.mat')

mpc_data_table_heat;
t_heat = mpc_data_table_heat.Time;
T = mpc_data_table_heat.t_val;
u_heater = mpc_data_table_heat.u_heater;
w_heat = mpc_data_table_heat.w_heat; 

w_temp = 30; 
w_night = 27; 

load('mpc_data_log_humid.mat')

mpc_data_table_humid;
t_humid = mpc_data_table_humid.Time;
h = mpc_data_table_humid.hum_val;
u_humid = mpc_data_table_humid.u_humid;
w_humid = mpc_data_table_humid.w_humid; 

w_hum = 27; 
w_night = 27; 

set(0, 'DefaultLineLineWidth', 2)
set(groot, ['Default', 'Stair', 'LineWidth'], 2)
%% 14.3.2025
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2025;
    month = 03; 
    day = 14;
%   idx = find(w == 27);
    t_index = find(t_heat.Year == year & t_heat.Month == month & t_heat.Day == day & w_heat == 30 & w_hum == 27);
    t_index = t_index(6:end);
    stairs([0:numel(t_index)-1], w_heat(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_temp-3 w_temp+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_heater(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([0 100])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
f2p('14_03_25_heat', 'linewidth', 2, 'Ysplit', 4)
% f2p('14_03_25_heat', 'linewidth', 2, 'extension', 'pdf', 'Ysplit', 4)

figure

subplot(2,1,1), hold on, box on, grid on
    year = 2025;
    month = 03; 
    day = 14;
%   idx = find(w == 27);
    t_index = find(t_humid.Year == year & t_humid.Month == month & t_humid.Day == day & w_hum == 27);
    t_index = t_index(7:end);
    stairs([0:numel(t_index)-1], w_humid(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], h(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_hum-3 w_hum+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$h [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$h$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], u_humid(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 25*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([0 30])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
f2p('14_03_25_humid',  'linewidth', 2)
% f2p('14_03_25_humid', 'linewidth', 2, 'extension', 'pdf')
%%
load('mpc_data_log_heat.mat')

mpc_data_table_heat;
t_heat = mpc_data_table_heat.Time;
T = mpc_data_table_heat.t_val;
u_heater = mpc_data_table_heat.u_heater;
w_heat = mpc_data_table_heat.w_heat; 

w_temp = 30; 
w_night = 27; 

load('mpc_data_log_humid.mat')

mpc_data_table_humid;
t_humid = mpc_data_table_humid.Time;
h = mpc_data_table_humid.hum_val;
u_humid = mpc_data_table_humid.u_humid;
w_humid = mpc_data_table_humid.w_humid; 

w_hum = 25; 
w_night = 27; 

set(0, 'DefaultLineLineWidth', 2)
set(groot, ['Default', 'Stair', 'LineWidth'], 2)
%% 15.3.2025
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2025;
    month = 03; 
    day = 15;
%   idx = find(w == 27);
    t_index = find(t_heat.Year == year & t_heat.Month == month & t_heat.Day == day & w_heat == 30);
    t_index = t_index(1:end-6);
    stairs([0:numel(t_index)-1], w_heat(t_index), 'k--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_temp-3 w_temp+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$r_{\mathrm{T}}$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 15, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid on
    stairs([0:numel(t_index)-1], u_heater(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'k--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'k-.')
    xlim([0 numel(t_index)-1])
    ylim([0 100])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u_{\mathrm{heat}} \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u_{\mathrm{heat}}$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 15, 'Location', 'southeast')
    set(leg1, 'Orientation', 'vertical')
f2p('15_03_25_heat', 'linewidth', 2, 'Ysplit', 4)
% f2p('15_03_25_heat', 'linewidth', 2, 'extension', 'pdf', 'Ysplit', 4)

figure

subplot(2,1,1), hold on, box on, grid on
    year = 2025;
    month = 03; 
    day = 15;
%   idx = find(w == 27);
    t_index = find(t_humid.Year == year & t_humid.Month == month & t_humid.Day == day & w_hum == 25);
    t_index = t_index(1:end-6);
    stairs([0:numel(t_index)-1], w_humid(t_index), 'k--')
 
    stairs([0:numel(t_index)-1], h(t_index))
    plot([0:numel(t_index)-1], 24*ones(1, numel(t_index)), ':', 'Color', [0.3529, 0.3529, 0.3529])
    plot([0:numel(t_index)-1], 26*ones(1, numel(t_index)), ':', 'Color', [0.3529, 0.3529, 0.3529])
    xlim([0 numel(t_index)-1])
    ylim([w_hum-3 w_hum+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$h [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$r_{\mathrm{h}}$', '$h$', '$\pm \delta$', 'interpreter', 'latex');
    set(leg, 'FontSize', 15, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid on
    stairs([0:numel(t_index)-1], u_humid(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'k--')
    plot([0:numel(t_index)-1], 25*ones(1, numel(t_index)), 'k-.')
    xlim([0 numel(t_index)-1])
    ylim([0 30])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u_{\mathrm{humid}} \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u_{\mathrm{humid}}$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 15, 'Location', 'southeast')
    set(leg1, 'Orientation', 'vertical')
f2p('15_03_25_humid',  'linewidth', 2)
% f2p('15_03_25_humid', 'linewidth', 2, 'extension', 'pdf')

%TEMPERATURE
ISE = 0;
x = T(t_index);
y = w_temp;
for i = [1:55]
    err = (x(i) - y)^2;
    ISE = ISE + err;
end
ISE_15_3 = ISE; % Ts = 1 min.

z = u_heater(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO = 0;
for i = [1:55]
    err = (z(i) - zz(i))^2;
    SSO = SSO + err;
end
SSO_15_3 = SSO; % Ts = 1 min.

NSSO_15_3 = ISE/10 + SSO/100000;

uu = u_heater(t_index)/100;
E_J = 0;
for i = [1:55]
    vykon = 60*40*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J = E_J + vykon; % Joules
end
E_kJ_15_3 = E_J/1000 % Kilojoules

E_kWh_15_3 = E_kJ_15_3/(3.6*10^3);
mCO2_15_3 = E_kWh_15_3*266

%HUMIDITY
ISE = 0;
x = T(t_index);
y = w_hum;
for i = [1:55]
    err = (x(i) - y)^2;
    ISE = ISE + err;
end
ISE_hum_15_3 = ISE; % Ts = 1 min.

z = u_humid(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO = 0;
for i = [1:55]
    err = (z(i) - zz(i))^2;
    SSO = SSO + err;
end
SSO_hum_15_3 = SSO; % Ts = 1 min.

NSSO_hum_15_3 = ISE/10 + SSO/100000;

uu = u_humid(t_index)/25;
E_J = 0;
for i = [1:55]
    vykon = 60*5.4*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J = E_J + vykon; % Joules
end
E_kJ_hum_15_3 = E_J/1000 % Kilojoules

E_kWh_hum_15_3 = E_kJ_hum_15_3/(3.6*10^3);
mCO2_hum_15_3 = E_kWh_hum_15_3*266
%%
load('mpc_data_log_heat.mat')

mpc_data_table_heat;
t_heat = mpc_data_table_heat.Time;
T = mpc_data_table_heat.t_val;
u_heater = mpc_data_table_heat.u_heater;
w_heat = mpc_data_table_heat.w_heat; 

w_temp = 30; 
w_night = 27; 

load('mpc_data_log_humid.mat')

mpc_data_table_humid;
t_humid = mpc_data_table_humid.Time;
h = mpc_data_table_humid.hum_val;
u_humid = mpc_data_table_humid.u_humid;
w_humid = mpc_data_table_humid.w_humid; 

w_hum = 25; 
w_night = 27; 

set(0, 'DefaultLineLineWidth', 2)
set(groot, ['Default', 'Stair', 'LineWidth'], 2)
%% 27.3.2025
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2025;
    month = 03; 
    day = 27;
%   idx = find(w == 27);
    t_index = find(t_heat.Year == year & t_heat.Month == month & t_heat.Day == day & w_heat == 30);
    t_index = t_index(1:end-77);
    stairs([0:numel(t_index)-1], w_heat(t_index), 'k--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_temp-3 w_temp+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$r_{\mathrm{T}}$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 15, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid on
    stairs([0:numel(t_index)-1], u_heater(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'k--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'k-.')
    xlim([0 numel(t_index)-1])
    ylim([0 100])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u_{\mathrm{heat}} \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u_{\mathrm{heat}}$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 15, 'Location', 'southeast')
    set(leg1, 'Orientation', 'vertical')
f2p('27_03_25_heat', 'linewidth', 2, 'Ysplit', 4)
% f2p('27_03_25_heat', 'linewidth', 2, 'extension', 'pdf', 'Ysplit', 4)

figure

subplot(2,1,1), hold on, box on, grid on
    year = 2025;
    month = 03; 
    day = 27;
%   idx = find(w == 27);
    t_index = find(t_humid.Year == year & t_humid.Month == month & t_humid.Day == day & w_hum == 25);
    t_index = t_index(1:end-77);
    stairs([0:numel(t_index)-1], w_humid(t_index), 'k--')
 
    stairs([0:numel(t_index)-1], h(t_index))
    plot([0:numel(t_index)-1], 24*ones(1, numel(t_index)), ':', 'Color', [0.3529, 0.3529, 0.3529])
    plot([0:numel(t_index)-1], 26*ones(1, numel(t_index)), ':', 'Color', [0.3529, 0.3529, 0.3529])
    xlim([0 numel(t_index)-1])
    ylim([w_hum-3 w_hum+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$h [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$r_{\mathrm{h}}$', '$h$', '$\pm \delta$', 'interpreter', 'latex');
    set(leg, 'FontSize', 15, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid on
    stairs([0:numel(t_index)-1], u_humid(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'k--')
    plot([0:numel(t_index)-1], 25*ones(1, numel(t_index)), 'k-.')
    xlim([0 numel(t_index)-1])
    ylim([0 30])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u_{\mathrm{humid}} \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u_{\mathrm{humid}}$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 15, 'Location', 'southeast')
    set(leg1, 'Orientation', 'vertical')
f2p('27_03_25_humid',  'linewidth', 2)
% f2p('27_03_25_humid', 'linewidth', 2, 'extension', 'pdf')

%TEMPERATURE
ISE = 0;
x = T(t_index);
y = w_temp;
for i = [1:55]
    err = (x(i) - y)^2;
    ISE = ISE + err;
end
ISE_27_3 = ISE; % Ts = 1 min.

z = u_heater(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO = 0;
for i = [1:55]
    err = (z(i) - zz(i))^2;
    SSO = SSO + err;
end
SSO_27_3 = SSO; % Ts = 1 min.

NSSO_27_3 = ISE/10 + SSO/100000;

uu = u_heater(t_index)/100;
E_J = 0;
for i = [1:55]
    vykon = 60*40*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J = E_J + vykon; % Joules
end
E_kJ_27_3 = E_J/1000 % Kilojoules

E_kWh_27_3 = E_kJ_27_3/(3.6*10^3);
mCO2_27_3 = E_kWh_27_3*266

%HUMIDITY
ISE = 0;
x = T(t_index);
y = w_hum;
for i = [1:55]
    err = (x(i) - y)^2;
    ISE = ISE + err;
end
ISE_hum_27_3 = ISE; % Ts = 1 min.

z = u_humid(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO = 0;
for i = [1:55]
    err = (z(i) - zz(i))^2;
    SSO = SSO + err;
end
SSO_hum_27_3 = SSO; % Ts = 1 min.

NSSO_hum_27_3 = ISE/10 + SSO/100000;

uu = u_humid(t_index)/25;
E_J = 0;
for i = [1:55]
    vykon = 60*5.4*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J = E_J + vykon; % Joules
end
E_kJ_hum_27_3 = E_J/1000 % Kilojoules

E_kWh_hum_27_3 = E_kJ_hum_27_3/(3.6*10^3);
mCO2_hum_27_3 = E_kWh_hum_27_3*266
%%
load('mpc_data_log_heat.mat')

mpc_data_table_heat;
t_heat = mpc_data_table_heat.Time;
T = mpc_data_table_heat.t_val;
u_heater = mpc_data_table_heat.u_heater;
w_heat = mpc_data_table_heat.w_heat; 

w_temp = 30; 
w_night = 27; 

load('mpc_data_log_humid.mat')

mpc_data_table_humid;
t_humid = mpc_data_table_humid.Time;
h = mpc_data_table_humid.hum_val;
u_humid = mpc_data_table_humid.u_humid;
w_humid = mpc_data_table_humid.w_humid; 

w_hum = 25; 
w_night = 27; 

set(0, 'DefaultLineLineWidth', 2)
set(groot, ['Default', 'Stair', 'LineWidth'], 2)
%% 27.3.2025 - second
figure

subplot(2,1,1), hold on, box on, grid on
    year = 2025;
    month = 03; 
    day = 27;
%   idx = find(w == 27);
    t_index = find(t_heat.Year == year & t_heat.Month == month & t_heat.Day == day & w_heat == 30);
    t_index = t_index(65:end-13);   
    stairs([0:numel(t_index)-1], w_heat(t_index), 'k--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_temp-3 w_temp+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$r_{\mathrm{T}}$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 15, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid on
    stairs([0:numel(t_index)-1], u_heater(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'k--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'k-.')
    xlim([0 numel(t_index)-1])
    ylim([0 100])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u_{\mathrm{heat}} \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u_{\mathrm{heat}}$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 15, 'Location', 'southeast')
    set(leg1, 'Orientation', 'vertical')
f2p('27_03_25_heat2', 'linewidth', 2, 'Ysplit', 4)
% f2p('27_03_25_heat2', 'linewidth', 2, 'extension', 'pdf', 'Ysplit', 4)

figure

subplot(2,1,1), hold on, box on, grid on
    year = 2025;
    month = 03; 
    day = 27;
%   idx = find(w == 27);
    t_index = find(t_humid.Year == year & t_humid.Month == month & t_humid.Day == day & w_hum == 25);
    t_index = t_index(65:end-13);
    stairs([0:numel(t_index)-1], w_humid(t_index), 'k--')
 
    stairs([0:numel(t_index)-1], h(t_index))
    plot([0:numel(t_index)-1], 24*ones(1, numel(t_index)), ':', 'Color', [0.3529, 0.3529, 0.3529])
    plot([0:numel(t_index)-1], 26*ones(1, numel(t_index)), ':', 'Color', [0.3529, 0.3529, 0.3529])
    xlim([0 numel(t_index)-1])
    ylim([w_hum-3 w_hum+3])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$h [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$r_{\mathrm{h}}$', '$h$', '$\pm \delta$', 'interpreter', 'latex');
    set(leg, 'FontSize', 15, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
 
subplot(2,1,2), hold on, box on, grid on
    stairs([0:numel(t_index)-1], u_humid(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'k--')
    plot([0:numel(t_index)-1], 25*ones(1, numel(t_index)), 'k-.')
    xlim([0 numel(t_index)-1])
    ylim([0 30])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u_{\mathrm{humid}} \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u_{\mathrm{humid}}$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 15, 'Location', 'southeast')
    set(leg1, 'Orientation', 'vertical')
f2p('27_03_25_humid2',  'linewidth', 2)
% f2p('27_03_25_humid2', 'linewidth', 2, 'extension', 'pdf')

%TEMPERATURE
ISE = 0;
x = T(t_index);
y = w_temp;
for i = [1:55]
    err = (x(i) - y)^2;
    ISE = ISE + err;
end
ISE_27_3_2 = ISE; % Ts = 1 min.

z = u_heater(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO = 0;
for i = [1:55]
    err = (z(i) - zz(i))^2;
    SSO = SSO + err;
end
SSO_27_3_2 = SSO; % Ts = 1 min.

NSSO_27_3_2 = ISE/10 + SSO/100000;

uu = u_heater(t_index)/100;
E_J = 0;
for i = [1:55]
    vykon = 60*40*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J = E_J + vykon; % Joules
end
E_kJ_27_3_2 = E_J/1000 % Kilojoules

E_kWh_27_3_2 = E_kJ_27_3_2/(3.6*10^3);
mCO2_27_3_2 = E_kWh_27_3_2*266

%HUMIDITY
ISE = 0;
x = T(t_index);
y = w_hum;
for i = [1:55]
    err = (x(i) - y)^2;
    ISE = ISE + err;
end
ISE_hum_27_3_2 = ISE; % Ts = 1 min.

z = u_humid(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO = 0;
for i = [1:55]
    err = (z(i) - zz(i))^2;
    SSO = SSO + err;
end
SSO_hum_27_3_2 = SSO; % Ts = 1 min.

NSSO_hum_27_3_2 = ISE/10 + SSO/100000;

uu = u_humid(t_index)/25;
E_J = 0;
for i = [1:55]
    vykon = 60*5.4*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J = E_J + vykon; % Joules
end
E_kJ_hum_27_3_2 = E_J/1000 % Kilojoules

E_kWh_hum_27_3_2 = E_kJ_hum_27_3_2/(3.6*10^3);
mCO2_hum_27_3_2 = E_kWh_hum_27_3_2*266