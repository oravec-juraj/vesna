%% all transition functions
% 
% % Load the data from the file
% load('example__23_03_24_02_50_39_[33.66.100].mat', 'all_times', 'all_temperatures');
% 
% % Convert datetime strings to numeric array
% numeric_times = zeros(size(all_times)); % Preallocate numeric_times array
% for i = 1:numel(all_times)
%     numeric_times(i) = datenum(all_times{i}); % Convert each datetime string to numeric
% end
% 
% % Extract step changes in humidity
% humidity_step_changes = [33,66,100];
% 
% % Extract temperature values
% temperature_values = all_temperatures;
% 
% % Fit a single transition function for all step changes in humidity
% transition_functions = cell(length(humidity_step_changes), 1);
% 
% % Plot all temperature values and the transition function
% figure;
% hold on;
% for i = 1:length(humidity_step_changes)
%     % Find the indices corresponding to the current step change
%     idx_start = humidity_step_changes(i);
%     if i < length(humidity_step_changes)
%         idx_end = humidity_step_changes(i+1) - 1;
%     else
%         idx_end = length(all_times);
%     end
%     idx = idx_start:idx_end;
% 
%     % Extract temperature values corresponding to the current step change
%     temperature_values_subset = temperature_values(idx);
%     datetime_range = numeric_times(idx); % Use numeric times for plotting
% 
%     % Fit a transition function (e.g., polynomial) to the temperature values
%     if numel(idx) >= 4 % Ensure at least 4 data points for polynomial fitting
%         % Center and scale the datetime values
%         mean_datetime = mean(datetime_range);
%         std_datetime = std(datetime_range);
%         datetime_range_scaled = (datetime_range - mean_datetime) / std_datetime;
% 
%         % Fit the polynomial to the scaled datetime values
%         p = polyfit(datetime_range_scaled, temperature_values_subset, 3); % Adjust the polynomial degree as needed
% 
%         % Evaluate the transition function for plotting
%         transition_temperature = polyval(p, datetime_range_scaled); % Evaluate the transition function
% 
%         % Display the coefficients of the transition function
%         disp(['Transition function coefficients for step change ', num2str(i), ':']);
%         disp(p);
% 
%         % Plot the measured temperature values
%         plot(datetime_range, temperature_values_subset, 'b-', 'LineWidth', 2);
% 
%         % Plot the transition function
%         plot(datetime_range, transition_temperature, 'r-', 'LineWidth', 2);
% 
%         % Store the transition function coefficients
%         transition_functions{i} = p;
%     else
%         disp(['Skipping transition function fitting for step change ', num2str(i), ' due to insufficient data points.']);
%     end
% end
% 
% xlabel('Time');
% ylabel('Temperature (°C)');
% title('Transition Function for All Step Changes in Humidity');
% legend('Measured Data', 'Transition Function');
% grid on;
% 
% % Save transition function coefficients for later use
% % save('transition_function_coefficients.mat', 'transition_functions');

%% 

load('fans_33_66_100_175520.mat', 'all_temperatures');
time = (0:10:(length(all_temperatures)-1)*10)'; 

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

% Z1 = (y_inf - y_null)/ (u_inf - u_null)
% T1 = g(n)*t_n
% D1 = (fs-fn)*tn
% tn = t2-t1    tu = t1-t0   fs = tu/tn
t2 = 4100;
t1 = 2970;
t0 = 2400;
Z = (26.904-27.678)/100
tn = t2-t1
tu = t1-t0
fs = tu/tn
T = 0.161 * tn
D = (fs - 0.493)*tn


%Z = -0.0117
%T = 181.93
%D = 12.91


% dalej nepodstatne

 %%
clc, clear
load('fans_0_232405.mat', 'all_temperatures');
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

t2 = 4100;
t1 = 2970;
t0 = 2400;
Z = (26.904-27.678)/66
tn = t2-t1
tu = t1-t0
fs = tu/tn
T = 0.161 * tn
D = (fs - 0.493)*tn

%%
clc,clear
load('fans_50_0_001633.mat', 'all_temperatures');
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

t2 = 2500;
t1 = 1300;
t0 = 1050;
Z = (27.504-26.822)/(0-100)
tn = t2-t1
tu = t1-t0
fs = tu/tn
T = 0.368 * tn
D = (fs - 0.104)*tn

%Z = -0.0068
%T = 441,6
%D = 125.2

%%
clc, clear
load('fans_75_50_25_0_045402.mat', 'all_temperatures');
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

t2 = 7330;
t1 = 3100;
t0 = 1630;
Z = (27.278-26.397)/(0-100)
tn = t2-t1
tu = t1-t0
fs = tu/tn
T = 0.224 * tn
D = (fs - 0.319)*tn

%Z = -0.0088
%T = 947.52
%D = 120.63
%%
clc,clear
load('fans_100_141139.mat', 'all_temperatures');
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

t2 = 6890;
t1 = 5480;
t0 = 4830;
Z = (27.321-28.081)/(100-0)
tn = t2-t1
tu = t1-t0
fs = tu/tn
T = 0.195 * tn
D = (fs - 0.410)*tn

%Z = -0.0076
%T = 274.95
%D = 71.9

%%
clc,clear
load('fans_50_100_102109.mat', 'all_temperatures');
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

t2 = 2320;
t1 = 1540;
t0 = 960;
Z = (27.275-27.845)/(100-0)
tn = t2-t1
tu = t1-t0
fs = tu/tn
T = 0.161 * tn
D = (fs - 0.493)*tn

%Z = -0.0057
%T = 125.58
%D = 195.46

%%
clc,clear
load('fans_25_50_75_100_234913.mat', 'all_temperatures');
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

t2 = 8880;
t1 = 6420;
t0 = 6120;
Z = (26.350-27.386)/(100-0)
tn = t2-t1
tu = t1-t0
fs = tu/tn
T = 0.368 * tn
D = (fs - 0.104)*tn

%Z = -0.0104
%T = 905.28
%D = 44.16
%%
clc,clear
load('fans_66_33_0_193234.mat', 'all_temperatures');
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

t2 = 4770;
t1 = 2470;
t0 = 1940;
Z = (28.303-27.325)/(0-66)
tn = t2-t1
tu = t1-t0
fs = tu/tn
T = 0.271 * tn
D = (fs - 0.218)*tn

%Z = -0.0148
%T = 623.3
%D = 28.6


