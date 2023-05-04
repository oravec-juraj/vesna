%%
load('mpc_data_log.mat')

mpc_data_table;
t = mpc_data_table.Time;
T = mpc_data_table.t_val;
u = mpc_data_table.u;
w = mpc_data_table.w; 

w_day = 28; % Forced temperature setpoint in vesna_control
w_night = 28; % Forced temperature setpoint in vesna_control

set(0, 'DefaultLineLineWidth', 2)
set(groot, ['Default', 'Stair', 'LineWidth'], 2)
%% 23.3.2023 - Q = 1000, Qi = 1000, R = 1.
figure(100)

subplot(2,1,1), hold on, box on, grid minor
    year = 2023;
    month = 03;
    day = 23;
%   idx = find(w == 28);
    t_index = find(t.Year == year & t.Month == month & t.Day == day & w == 28);
    stairs([0:numel(t_index)-1], w(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_day-2 w_day+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
    title('$Q_{\mathrm{x}} = 1000, \ Q_{\mathrm{y}} = 1000, \ R=1$', 'interpreter', 'latex', 'FontSize', 15)
 
subplot(2,1,2), hold on, box on, grid minor
    stairs([0:numel(t_index)-1], (20/51)*u(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([-10 140])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$', '$u_{\mathrm{min}}$', '$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
%     title('$Q = 1000, \ Q_{\mathrm{i}} = 1000, \ R=1$', 'interpreter', 'latex', 'FontSize', 20)

% print(gcf, '-dpng', '1000_1000_1', '-r600')
ISE_1 = 0;
x = T(t_index);
y = w(t_index);
for i = [1:numel(t_index)]
    err = (x(i) - y(i))^2;
    ISE_1 = ISE_1 + err;
end
ISE_1 = ISE_1 % Ts = 1 min.

z = u(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO_1 = 0;
for i = [1:numel(t_index)]
    err = (z(i) - zz(i))^2;
    SSO_1 = SSO_1 + err;
end
SSO_1 = SSO_1 % Ts = 1 min.

NSSO_1 = ISE_1/10 + SSO_1/100000

uu = u(t_index)/255;
E_J_1 = 0;
for i = [1:numel(t_index)]
    vykon = 60*40*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J_1 = E_J_1 + vykon; % Joules
end
E_kJ_1 = E_J_1/1000 % Kilojoules
  %% 27.3.2023 - Q = 1000, Qi = 1000, R = 0.1  
  figure(101)

subplot(2,1,1), hold on, box on, grid minor
    year = 2023;
    month = 03;
    day = 27;
%   idx = find(w == 28);
    t_index = find(t.Year == year & t.Month == month & t.Day == day & w == 28 & t.Hour == 15);

    stairs([0:numel(t_index)-1], w(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_day-2.5 w_day+2.5])
    xlabel('$t$ [min]', 'interpreter', 'latex')
    ylabel('$T [^\circ C]$', 'interpreter', 'latex')
    legend('$w$', '$T$', 'interpreter', 'latex')
    title('$MPC \ riadenie \ teploty \ na \ VESNA \ 27.3.2023 \ s \ maticou \ R=0.1, \ Q \ a \ Q_{\mathrm{i}} = 1000.$', 'interpreter', 'latex')
 
subplot(2,1,2), hold on, box on, grid minor

    stairs([0:numel(t_index)-1], u(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 255*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([-20 275])
    xlabel('$t$ [min]', 'interpreter', 'latex')
    ylabel('$u \ [\%]$', 'interpreter', 'latex')
    legend('$u$','$u_{\mathrm{min}}$','$u_{\mathrm{max}}$', 'interpreter', 'latex')
    title('$Akcne \ zasahy \ pri \ riadeni \ teploty \ 27.3.2023$', 'interpreter', 'latex')
%% 3.4.2023 - Q = 1000, Qi = 1000, R = 2.
figure(102)

subplot(2,1,1), hold on, box on, grid minor
    year = 2023;
    month = 04;
    day = 03;
    hour = 12;
%   idx = find(w == 28);
    t_index = find(t.Year == year & t.Month == month & t.Day == day & w == 28 & t.Hour == hour);

    stairs([0:numel(t_index)-1], w(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_day-2 w_day+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
    title('$Q_{\mathrm{x}} = 1000, \ Q_{\mathrm{y}} = 1000, \ R=2$', 'interpreter', 'latex', 'FontSize', 15)
 
subplot(2,1,2), hold on, box on, grid minor

    stairs([0:numel(t_index)-1], (20/51)*u(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([-10 140])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$','$u_{\mathrm{min}}$','$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
%     title('$Akcne \ zasahy \ pri \ riadeni \ teploty \ 3.4.2023$', 'interpreter', 'latex')

% print(gcf, '-dpng', '1000_1000_2', '-r600')

ISE_2 = 0;
x = T(t_index);
y = w(t_index);
for i = [1:numel(t_index)]
    err = (x(i) - y(i))^2;
    ISE_2 = ISE_2 + err;
end
ISE_2 = ISE_2 % Ts = 1 min.

z = u(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO_2 = 0;
for i = [1:numel(t_index)]
    err = (z(i) - zz(i))^2;
    SSO_2 = SSO_2 + err;
end
SSO_2 = SSO_2 % Ts = 1 min.

NSSO_2 = ISE_2/10 + SSO_2/100000

uu = u(t_index)/255;
E_J_2 = 0;
for i = [1:numel(t_index)]
    vykon = 60*40*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J_2 = E_J_2 + vykon; % Joules
end
E_kJ_2 = E_J_2/1000 % Kilojoules
%% 3.4.2023 - Q = 900, Qi = 900, R = 2.
figure(103)

subplot(2,1,1), hold on, box on, grid minor
    year = 2023;
    month = 04;
    day = 03;
    hour = 13;
%   idx = find(w == 28);
    t_index = find(t.Year == year & t.Month == month & t.Day == day & w == 28 & t.Hour == hour);

    stairs([0:numel(t_index)-1], w(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_day-2 w_day+2])
    xlabel('$t$ [min]', 'interpreter', 'latex')
    ylabel('$T [^\circ C]$', 'interpreter', 'latex')
    legend('$w$', '$T$', 'interpreter', 'latex')
    title('$MPC \ riadenie \ teploty \ na \ VESNA \ 3.4.2023 \ s \ maticou \ R=2, \ Q \ a \ Q_{\mathrm{i}} = 900.$', 'interpreter', 'latex')
 
subplot(2,1,2), hold on, box on, grid minor

    stairs([0:numel(t_index)-1], u(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 255*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([-20 275])
    xlabel('$t$ [min]', 'interpreter', 'latex')
    ylabel('$u \ [\%]$', 'interpreter', 'latex')
    legend('$u$','$u_{\mathrm{min}}$','$u_{\mathrm{max}}$', 'interpreter', 'latex')
    title('$Akcne \ zasahy \ pri \ riadeni \ teploty \ 3.4.2023$', 'interpreter', 'latex')
%% 3.4.2023 - Q = 1100, Qi = 1100, R = 1.5.
figure(104)

subplot(2,1,1), hold on, box on, grid minor
    year = 2023;
    month = 04;
    day = 03;
    hour = 14;
%   idx = find(w == 28);
    t_index = find(t.Year == year & t.Month == month & t.Day == day & w == 28 & t.Hour == hour);

    stairs([0:numel(t_index)-1], w(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_day-2 w_day+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
    title('$Q_{\mathrm{x}} = 1100, \ Q_{\mathrm{y}} = 1100, \ R=1.5$', 'interpreter', 'latex', 'FontSize', 15)
 
subplot(2,1,2), hold on, box on, grid minor

    stairs([0:numel(t_index)-1], (20/51)*u(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([-10 140])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$','$u_{\mathrm{min}}$','$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
%     title('$Akcne \ zasahy \ pri \ riadeni \ teploty \ 3.4.2023$', 'interpreter', 'latex')

% print(gcf, '-dpng', '1100_1100', '-r600')

ISE_3 = 0;
x = T(t_index);
y = w(t_index);
for i = [1:numel(t_index)]
    err = (x(i) - y(i))^2;
    ISE_3 = ISE_3 + err;
end
ISE_3 = ISE_3 % Ts = 1 min.

z = u(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO_3 = 0;
for i = [1:numel(t_index)]
    err = (z(i) - zz(i))^2;
    SSO_3 = SSO_3 + err;
end
SSO_3 = SSO_3 % Ts = 1 min.

NSSO_3 = ISE_3/10 + SSO_3/100000

uu = u(t_index)/255;
E_J_3 = 0;
for i = [1:numel(t_index)]
    vykon = 60*40*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J_3 = E_J_3 + vykon; % Joules
end
E_kJ_3 = E_J_3/1000 % Kilojoules
%% 3.4.2023 - Q = 1000, Qi = 1000, R = 1.5.
figure(105)

subplot(2,1,1), hold on, box on, grid minor
    year = 2023;
    month = 04;
    day = 03;
    hour = 15;
%   idx = find(w == 28);
    t_index = find(t.Year == year & t.Month == month & t.Day == day & w == 28 & t.Hour == hour);

    stairs([0:numel(t_index)-1], w(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_day-2 w_day+2])
    xlabel('$t$ [min]', 'interpreter', 'latex')
    ylabel('$T [^\circ C]$', 'interpreter', 'latex')
    legend('$w$', '$T$', 'interpreter', 'latex')
    title('$MPC \ riadenie \ teploty \ na \ VESNA \ 3.4.2023 \ s \ maticou \ R=1.5, \ Q \ a \ Q_{\mathrm{i}} = 1000.$', 'interpreter', 'latex')
 
subplot(2,1,2), hold on, box on, grid minor

    stairs([0:numel(t_index)-1], (20/51)*u(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([-10 140])
    xlabel('$t$ [min]', 'interpreter', 'latex')
    ylabel('$u \ [\%]$', 'interpreter', 'latex')
    legend('$u$','$u_{\mathrm{min}}$','$u_{\mathrm{max}}$', 'interpreter', 'latex')
    title('$Akcne \ zasahy \ pri \ riadeni \ teploty \ 3.4.2023$', 'interpreter', 'latex')
%% 6.4.2023 - Q = 1000, Qi = 1000, R = 1.5 but from 26 degrees
figure(106)

subplot(2,1,1), hold on, box on, grid minor
    year = 2023;
    month = 04;
    day = 06;
%   idx = find(w == 28);
    t_index = find(t.Year == year & t.Month == month & t.Day == day & w == 28);

    stairs([0:numel(t_index)-1], w(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_day-2 w_day+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
    title('$Q_{\mathrm{x}} = 1000, \ Q_{\mathrm{y}} = 1000, \ R=1.5$', 'interpreter', 'latex', 'FontSize', 15)
 
subplot(2,1,2), hold on, box on, grid minor

    stairs([0:numel(t_index)-1], (20/51)*u(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([-10 140])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$','$u_{\mathrm{min}}$','$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
%     title('$Akcne \ zasahy \ pri \ riadeni \ teploty \ 6.4.2023$', 'interpreter', 'latex')

% print(gcf, '-dpng', '1000_1000_1_5', '-r600')

ISE_4 = 0;
x = T(t_index);
y = w(t_index);
for i = [1:numel(t_index)]
    err = (x(i) - y(i))^2;
    ISE_4 = ISE_4 + err;
end
ISE_4 = ISE_4 % Ts = 1 min.

z = u(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO_4 = 0;
for i = [1:numel(t_index)]
    err = (z(i) - zz(i))^2;
    SSO_4 = SSO_4 + err;
end
SSO_4 = SSO_4 % Ts = 1 min.

NSSO_4 = ISE_4/10 + SSO_4/100000

uu = u(t_index)/255;
E_J_4 = 0;
for i = [1:numel(t_index)]
    vykon = 60*40*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J_4 = E_J_4 + vykon; % Joules
end
E_kJ_4 = E_J_4/1000 % Kilojoules
%% 11.4.2023 - Q = 1000, Qi = 1000, R = 15
figure(107)

subplot(2,1,1), hold on, box on, grid minor
    year = 2023;
    month = 04;
    day = 11;
%   idx = find(w == 28);
    t_index = find(t.Year == year & t.Month == month & t.Day == day & t.Hour == 14 & w == 28);

    stairs([0:numel(t_index)-1], w(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_day-2 w_day+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
    title('$Q_{\mathrm{x}} = 1000, \ Q_{\mathrm{y}} = 1000, \ R=15$', 'interpreter', 'latex', 'FontSize', 15)
 
subplot(2,1,2), hold on, box on, grid minor

    stairs([0:numel(t_index)-1], (20/51)*u(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([-10 140])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$','$u_{\mathrm{min}}$','$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
%     title('$Akcne \ zasahy \ pri \ riadeni \ teploty \ 11.4.2023$', 'interpreter', 'latex')
    
% print(gcf, '-dpng', '1000_1000_15', '-r600')

ISE_5 = 0;
x = T(t_index);
y = w(t_index);
for i = [1:numel(t_index)]
    err = (x(i) - y(i))^2;
    ISE_5 = ISE_5 + err;
end
ISE_5 = ISE_5 % Ts = 1 min.

z = u(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO_5 = 0;
for i = [1:numel(t_index)]
    err = (z(i) - zz(i))^2;
    SSO_5 = SSO_5 + err;
end
SSO_5 = SSO_5 % Ts = 1 min.

NSSO_5 = ISE_5/10 + SSO_5/100000

uu = u(t_index)/255;
E_J_5 = 0;
for i = [1:numel(t_index)]
    vykon = 60*40*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J_5 = E_J_5 + vykon; % Joules
end
E_kJ_5 = E_J_5/1000 % Kilojoules
%% 11.4.2023 - Q = 1000, Qi = 1000, R = 100
figure(108)

subplot(2,1,1), hold on, box on, grid minor
    year = 2023;
    month = 04;
    day = 11;
%   idx = find(w == 28);
    t_index = find(t.Year == year & t.Month == month & t.Day == day & t.Hour == 15 & t.Minute > 04 & w == 28);

    stairs([0:numel(t_index)-1], w(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_day-2 w_day+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
    title('$Q_{\mathrm{x}} = 1000, \ Q_{\mathrm{y}} = 1000, \ R=100$', 'interpreter', 'latex', 'FontSize', 15)
 
subplot(2,1,2), hold on, box on, grid minor

    stairs([0:numel(t_index)-1], (20/51)*u(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([-10 140])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$','$u_{\mathrm{min}}$','$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
%     title('$Akcne \ zasahy \ pri \ riadeni \ teploty \ 11.4.2023$', 'interpreter', 'latex')

% print(gcf, '-dpng', '1000_1000_100', '-r600')

ISE_6 = 0;
x = T(t_index);
y = w(t_index);
for i = [1:numel(t_index)]
    err = (x(i) - y(i))^2;
    ISE_6 = ISE_6 + err;
end
ISE_6 = ISE_6 % Ts = 1 min.

z = u(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO_6 = 0;
for i = [1:numel(t_index)]
    err = (z(i) - zz(i))^2;
    SSO_6 = SSO_6 + err;
end
SSO_6 = SSO_6 % Ts = 1 min.

NSSO_6 = ISE_6/10 + SSO_6/100000

uu = u(t_index)/255;
E_J_6 = 0;
for i = [1:numel(t_index)]
    vykon = 60*40*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J_6 = E_J_6 + vykon; % Joules
end
E_kJ_6 = E_J_6/1000 % Kilojoules
%% 11.4.2023 - Q = 2000, Qi = 1000, R = 15
figure(109)

subplot(2,1,1), hold on, box on, grid minor
    year = 2023;
    month = 04;
    day = 11;
%   idx = find(w == 28);
    t_index = find(t.Year == year & t.Month == month & t.Day == day & t.Hour == 16 & w == 28);

    stairs([0:numel(t_index)-1], w(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_day-2 w_day+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
    title('$Q_{\mathrm{x}} = 2000, \ Q_{\mathrm{y}} = 1000, \ R=15$', 'interpreter', 'latex', 'FontSize', 15)
 
subplot(2,1,2), hold on, box on, grid minor

    stairs([0:numel(t_index)-1], (20/51)*u(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([-10 140])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$','$u_{\mathrm{min}}$','$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
%     title('$Akcne \ zasahy \ pri \ riadeni \ teploty \ 11.4.2023$', 'interpreter', 'latex')

% print(gcf, '-dpng', '2000_1000_15', '-r600')

ISE_7 = 0;
x = T(t_index);
y = w(t_index);
for i = [1:numel(t_index)]
    err = (x(i) - y(i))^2;
    ISE_7 = ISE_7 + err;
end
ISE_7 = ISE_7 % Ts = 1 min.

z = u(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO_7 = 0;
for i = [1:numel(t_index)]
    err = (z(i) - zz(i))^2;
    SSO_7 = SSO_7 + err;
end
SSO_7 = SSO_7 % Ts = 1 min.

NSSO_7 = ISE_7/10 + SSO_7/100000

uu = u(t_index)/255;
E_J_7 = 0;
for i = [1:numel(t_index)]
    vykon = 60*40*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J_7 = E_J_7 + vykon; % Joules
end
E_kJ_7 = E_J_7/1000 % Kilojoules
%% 11.4.2023 - Q = 1500, Qi = 1000, R = 1.5
figure(110)

subplot(2,1,1), hold on, box on, grid minor
    year = 2023;
    month = 04;
    day = 11;
%   idx = find(w == 28);
    t_index = find(t.Year == year & t.Month == month & t.Day == day & t.Hour == 17 & t.Minute > 05 & w == 28);

    stairs([0:numel(t_index)-1], w(t_index), 'b--')
 
    stairs([0:numel(t_index)-1], T(t_index))
    xlim([0 numel(t_index)-1])
    ylim([w_day-2 w_day+2])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$T [^\circ C]$', 'interpreter', 'latex', 'FontSize', 15)
    leg = legend('$w$', '$T$', 'interpreter', 'latex');
    set(leg, 'FontSize', 10, 'Location', 'north')
    set(leg, 'Orientation', 'horizontal')
    title('$Q_{\mathrm{x}} = 1500, \ Q_{\mathrm{y}} = 1000, \ R=1.5$', 'interpreter', 'latex', 'FontSize', 15)
 
subplot(2,1,2), hold on, box on, grid minor

    stairs([0:numel(t_index)-1], (20/51)*u(t_index))
    plot([0:numel(t_index)-1], zeros(1, numel(t_index)), 'm--')
    plot([0:numel(t_index)-1], 100*ones(1, numel(t_index)), 'm--')
    xlim([0 numel(t_index)-1])
    ylim([-10 140])
    xlabel('$t$ [min]', 'interpreter', 'latex', 'FontSize', 15)
    ylabel('$u \ [\%]$', 'interpreter', 'latex', 'FontSize', 15)
    leg1 = legend('$u$','$u_{\mathrm{min}}$','$u_{\mathrm{max}}$', 'interpreter', 'latex');
    set(leg1, 'FontSize', 10, 'Location', 'north')
    set(leg1, 'Orientation', 'horizontal')
%     title('$Akcne \ zasahy \ pri \ riadeni \ teploty \ 11.4.2023$', 'interpreter', 'latex')

% print(gcf, '-dpng', '1500_1000_1_5', '-r600')
ISE_8 = 0;
x = T(t_index);
y = w(t_index);
for i = [1:numel(t_index)]
    err = (x(i) - y(i))^2;
    ISE_8 = ISE_8 + err;
end
ISE_8 = ISE_8 % Ts = 1 min.

z = u(t_index);
n_inf_vec = 5;
u_inf_vec = z(end-n_inf_vec+1:end);
u_inf = mean(u_inf_vec);
zz = u_inf*ones(1, numel(z));
SSO_8 = 0;
for i = [1:numel(t_index)]
    err = (z(i) - zz(i))^2;
    SSO_8 = SSO_8 + err;
end
SSO_8 = SSO_8 % Ts = 1 min.

NSSO_8 = ISE_8/10 + SSO_8/100000

uu = u(t_index)/255;
E_J_8 = 0;
for i = [1:numel(t_index)]
    vykon = 60*40*uu(i); % 60 seconds*40W (Js^-1 at 100%)*u from <0;1> interval
    E_J_8 = E_J_8 + vykon; % Joules
end
E_kJ_8 = E_J_8/1000 % Kilojoules