%% 
% load the file with arrays of time and temperatures
load('example__23_03_24_02_50_39_[33.66.100].mat', 'all_temperatures');
time = (0:10:(length(all_temperatures)-1)*10)'; % time array is more convenient to be done this way

% Define window size for moving average
window_size = 10;

% Apply moving average
smoothed_temperatures = movmean(all_temperatures, window_size);

% Plot original and smoothed data
plot(time, all_temperatures, 'b-', 'LineWidth', 1.5);
hold on;
plot(time(window_size:end), smoothed_temperatures(window_size:end), 'r-', 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Temperature');
title('Smoothing Temperature Data with Moving Average');
legend('Original Data', 'Smoothed Data (Moving Average)', 'Location', 'best');
grid on;
hold off;

% how to calculate your values of transfer function
% Z1 = (y_inf - y_null)/ (u_inf - u_null)
% T1 = g(n)*t_n
% D1 = (fs-fn)*tn
% tn = t2-t1    tu = t1-t0   fs = tu/tn
t2 = 15570;
t1 = 14200;
t0 = 13800;
Z = (26.3245-26.2446)/33
tn = t2-t1
tu = t1-t0
fs = tu/tn
T = 0.271 * tn
D = (fs - 0.218)*tn

% 0-33
Z1 = 0.0253;
fs1 = 0.4303;
T1 = 475.8;
D1 = 49.6;

% 33-66
Z2 = 0.0024;
fs2 = 0.292;
T2 = 371.2700;
D2 = 101.34;

% dalej nepodstatna zmena

 %% it is repeated for all step changes up and down. I have it separatelly this way. CHECK THE LAST SECTION
load('example__24_03_24_18_28_23_[100,0].mat', 'all_temperatures');
time = (0:10:(length(all_temperatures)-1)*10)'; 

% Define window size for moving average
window_size = 5;

% Apply moving average
smoothed_temperatures = movmean(all_temperatures, window_size);

% Plot original and smoothed data
plot(time, all_temperatures, 'b-', 'LineWidth', 1.5);
hold on;
plot(time(window_size:end), smoothed_temperatures(window_size:end), 'r-', 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Temperature');
title('Smoothing Temperature Data with Moving Average');
legend('Original Data', 'Smoothed Data (Moving Average)', 'Location', 'best');
grid on;
hold off;

% Z1 = (y_inf - y_null)/ (u_inf - u_null)
% T1 = g(n)*t_n
% D1 = (fs-fn)*tn
% tn = t2-t1    tu = t1-t0   fs = tu/tn
t2 = 950;
t1 = 870;
t0 = 870;
Z = (27.6383-27.5475)/100
tn = t2-t1
tu = t1-t0
fs = tu/tn
T = 1 * tn
D = (fs - 0)*tn

Z3 = 0.00091;
fs3 = 0;
T3 = 80;
D3 = 0;


%%
load('example__24_03_24_16_54_50_[50,0].mat', 'all_temperatures');
time = (0:10:(length(all_temperatures)-1)*10)'; 

% Define window size for moving average
window_size = 5;

% Apply moving average
smoothed_temperatures = movmean(all_temperatures, window_size);

% Plot original and smoothed data
plot(time, all_temperatures, 'b-', 'LineWidth', 1.5);
hold on;
plot(time(window_size:end), smoothed_temperatures(window_size:end), 'r-', 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Temperature');
title('Smoothing Temperature Data with Moving Average');
legend('Original Data', 'Smoothed Data (Moving Average)', 'Location', 'best');
grid on;
hold off;

% Z1 = (y_inf - y_null)/ (u_inf - u_null)
% T1 = g(n)*t_n
% D1 = (fs-fn)*tn
% tn = t2-t1    tu = t1-t0   fs = tu/tn
t2 = 2620;
t1 = 730;
t0 = 0;
Z = (27.3659-27.0294)/50
tn = t2-t1
tu = t1-t0
fs = tu/tn
T = 0.224 * tn
D = (fs - 0)*tn

Z4 = 0.0067;
fs4 = 0.3862;
T4 = 423.3600;
D4 = 730;

Z5 = 0.0098;
fs5 = 0;
T5 = 1210;
D5 = 0;


%%
load('example__24_03_24_13_56_56_[75, 50, 25, 0].mat', 'all_temperatures');
time = (0:10:(length(all_temperatures)-1)*10)'; 

% Define window size for moving average
window_size = 5;

% Apply moving average
smoothed_temperatures = movmean(all_temperatures, window_size);

% Plot original and smoothed data
plot(time, all_temperatures, 'b-', 'LineWidth', 1.5);
hold on;
plot(time(window_size:end), smoothed_temperatures(window_size:end), 'r-', 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Temperature');
title('Smoothing Temperature Data with Moving Average');
legend('Original Data', 'Smoothed Data (Moving Average)', 'Location', 'best');
grid on;
hold off;

% Z1 = (y_inf - y_null)/ (u_inf - u_null)
% T1 = g(n)*t_n
% D1 = (fs-fn)*tn
% tn = t2-t1    tu = t1-t0   fs = tu/tn
t2 = 15370;
t1 = 13500;
t0 = 12400;
Z = (27.0989-26.8313)/25
tn = t2-t1
tu = t1-t0
fs = tu/tn
T = 0.161 * tn
D = (fs - 0)*tn

Z6 = 0.0081;
fs6 = 0.0813;
T6 = 4060;
D6 = 330;

Z7 = 0.0044;
fs7 = 0;
T7 = 930;
D7 = 0;

Z8 = 0.0037;
fs8 = 0;
T8 = 2850;
D8 = 0;

Z9 = 0.0107;
fs9 = 0.5882;
T9 = 301.0700;
D9 = 1100;


%%
load('example__23_03_24_19_23_25_[100].mat', 'all_temperatures');
time = (0:10:(length(all_temperatures)-1)*10)'; 
% Define window size for moving average
window_size = 5;

% Apply moving average
smoothed_temperatures = movmean(all_temperatures, window_size);

% Plot original and smoothed data
plot(time, all_temperatures, 'b-', 'LineWidth', 1.5);
hold on;
plot(time(window_size:end), smoothed_temperatures(window_size:end), 'r-', 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Temperature');
title('Smoothing Temperature Data with Moving Average');
legend('Original Data', 'Smoothed Data (Moving Average)', 'Location', 'best');
grid on;
hold off;

% Z1 = (y_inf - y_null)/ (u_inf - u_null)
% T1 = g(n)*t_n
% D1 = (fs-fn)*tn
% tn = t2-t1    tu = t1-t0   fs = tu/tn
t2 = 5420;
t1 = 390;
t0 = 390;
Z = (26.7384-27.2644)/100
tn = t2-t1
tu = t1-t0
fs = tu/tn
T = 1 * tn
D = (fs - 0)*tn

Z10 = -0.0053;
fs10 = 0;
T10 = 5030;
D10 = 0;

%%
load('example__23_03_24_16_27_30_[50,100].mat', 'all_temperatures');
time = (0:10:(length(all_temperatures)-1)*10)'; 

% Define window size for moving average
window_size = 5;

% Apply moving average
smoothed_temperatures = movmean(all_temperatures, window_size);

% Plot original and smoothed data
plot(time, all_temperatures, 'b-', 'LineWidth', 1.5);
hold on;
plot(time(window_size:end), smoothed_temperatures(window_size:end), 'r-', 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Temperature');
title('Smoothing Temperature Data with Moving Average');
legend('Original Data', 'Smoothed Data (Moving Average)', 'Location', 'best');
grid on;
hold off;

% Z1 = (y_inf - y_null)/ (u_inf - u_null)
% T1 = g(n)*t_n
% D1 = (fs-fn)*tn
% tn = t2-t1    tu = t1-t0   fs = tu/tn
t2 = 152;
t1 = 1520;
t0 = 1520;
Z = (26.7346-27.7451)/50
tn = t2-t1
tu = t1-t0
fs = tu/tn
T = 1 * tn
D = (fs - 0)*tn

Z11 = -0.0010;
fs11 = 0.0813;
T11 = 4060;
D11 = 330;


%%
load('0,25,50,75,100.mat', 'all_temperatures');
time = (0:10:(length(all_temperatures)-1)*10)'; 

% Define window size for moving average
window_size = 5;

% Apply moving average
smoothed_temperatures = movmean(all_temperatures, window_size);

% Plot original and smoothed data
plot(time, all_temperatures, 'b-', 'LineWidth', 1.5);
hold on;
plot(time(window_size:end), smoothed_temperatures(window_size:end), 'r-', 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Temperature');
title('Smoothing Temperature Data with Moving Average');
legend('Original Data', 'Smoothed Data (Moving Average)', 'Location', 'best');
grid on;
hold off;

% Z1 = (y_inf - y_null)/ (u_inf - u_null)
% T1 = g(n)*t_n
% D1 = (fs-fn)*tn
% tn = t2-t1    tu = t1-t0   fs = tu/tn
t2 = 14890;
t1 = 12800;
t0 = 12800;
Z = (24.8558-25.0491)/25
tn = t2-t1
tu = t1-t0
fs = tu/tn
T = 1 * tn
D = (fs - 0)*tn


Z12 = -0.0069;
fs12 = 0;
T12 = 3630;
D12 = 0;

Z13 = -0.0276;
fs13 = 0;
T13 = 2510;
D13 = 0;

Z14 = -0.0037;
fs14 = 0;
T14 = 2410;
D14 = 0;

Z15 = -0.0077;
fs15 = 0;
T15 = 2090;
D15 = 0;


%%
load('100,66,33,0.mat', 'all_temperatures');
time = (0:10:(length(all_temperatures)-1)*10)'; 

% Define window size for moving average
window_size = 5;

% Apply moving average
smoothed_temperatures = movmean(all_temperatures, window_size);

% Plot original and smoothed data
plot(time, all_temperatures, 'b-', 'LineWidth', 1.5);
hold on;
plot(time(window_size:end), smoothed_temperatures(window_size:end), 'r-', 'LineWidth', 1.5);
xlabel('Time (seconds)');
ylabel('Temperature');
title('Smoothing Temperature Data with Moving Average');
legend('Original Data', 'Smoothed Data (Moving Average)', 'Location', 'best');
grid on;
hold off;

% Z1 = (y_inf - y_null)/ (u_inf - u_null)
% T1 = g(n)*t_n
% D1 = (fs-fn)*tn
% tn = t2-t1    tu = t1-t0   fs = tu/tn
t2 = 8090;
t1 = 7390;
t0 = 7390;
Z = (28.8399-28.3166)/33
tn = t2-t1
tu = t1-t0
fs = tu/tn
T = 1 * tn
D = (fs - 0)*tn


Z16 = 0.0091;
fs16 = 0;
T16 = 3240;
D16 = 0;

Z17 = 0.0056;
fs17 = 0;
T17 = 1280;
D17 = 0;

Z18 = 0.0159;
fs18 = 0;
T18 = 700;
D18 = 0;

%% average out of all measured values, I have D somewhere, however, 
% eventually, we did not take it into consideration

Z1 = 0.0253;
fs1 = 0.4303;
T1 = 475.8;
D1 = 49.6;

Z2 = 0.0024;
fs2 = 0.292;
T2 = 371.2700;
D2 = 101.34;

Z3 = 0.00091;
fs3 = 0;
T3 = 80;
D3 = 0;

Z4 = 0.0067;
fs4 = 0.3862;
T4 = 423.3600;
D4 = 730;

Z5 = 0.0098;
fs5 = 0;
T5 = 1210;
D5 = 0;

Z6 = 0.0081;
fs6 = 0.0813;
T6 = 4060;
D6 = 330;

Z7 = 0.0044;
fs7 = 0;
T7 = 930;
D7 = 0;

Z8 = 0.0037;
fs8 = 0;
T8 = 2850;
D8 = 0;

Z9 = 0.0107;
fs9 = 0.5882;
T9 = 301.0700;
D9 = 1100;

Z10 = 0.0053;
fs10 = 0;
T10 = 5030;
D10 = 0;

Z11 = 0.0010;
fs11 = 0.0813;
T11 = 4060;
D11 = 330;

Z12 = 0.0069;
fs12 = 0;
T12 = 3630;
D12 = 0;

Z13 = 0.0276;
fs13 = 0;
T13 = 2510;
D13 = 0;

Z14 = 0.0037;
fs14 = 0;
T14 = 2410;
D14 = 0;

Z15 = 0.0077;
fs15 = 0;
T15 = 2090;
D15 = 0;

Z16 = 0.0091;
fs16 = 0;
T16 = 3240;
D16 = 0;

Z17 = 0.0056;
fs17 = 0;
T17 = 1280;
D17 = 0;

Z18 = 0.0159;
fs18 = 0;
T18 = 700;
D18 = 0;

% Define arrays for Z, T, and D
Z_values = [Z1, Z2, Z3, Z4, Z5, Z6, Z7, Z8, Z9, Z10, Z11, Z12, Z13, Z14, Z15, Z16, Z17, Z18];
T_values = [T1, T2, T3, T4, T5, T6, T7, T8, T9, T10, T11, T12, T13, T14, T15, T16, T17, T18];
D_values = [D1, D2, D3, D4, D5, D6, D7, D8, D9, D10, D11, D12, D13, D14, D15, D16, D17, D18];

% Calculate absolute values (not needed step eventaully)
abs_Z = abs(Z_values);
abs_T = abs(T_values);
abs_D = abs(D_values);

% Calculate averages
average_Z = mean(abs_Z);
average_T = mean(abs_T);
average_D = mean(abs_D);

% Display results in command window
disp(['Average of absolute values for Z: ', num2str(average_Z)]);
disp(['Average of absolute values for T: ', num2str(average_T)]);
disp(['Average of absolute values for D: ', num2str(average_D)]);

% Saved values from command window
Z = 0.0086006;
T = 1980.6389;
D = 146.7189;
