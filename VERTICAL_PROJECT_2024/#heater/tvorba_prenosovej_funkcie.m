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

%% zaciatok

load('example__240412_144251', 'all_temperatures');
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

%% [100 66 33 0]

% 100-66
Z1 = 0.9135;
fs1 = 0;
T1 = 640;
D1 = 0;
% 66-33

Z2 = 2.7758;
fs2 = 0;
T2 = 1960;
D2 = 0;

% 33-0
Z3 = 2.347;
fs3 = 0; 
T3 = 1860; 
D3 = 0; 

%% [0 33 66 100]

% 0-33
Z4 = 2.1288; 
fs4 = 0.261; 
T4 = 249.32; 
D4 = 39.56; 

% 33-66
Z5 = 3.0264; 
fs5 = 0; 
T5 = 1200; 
D6 = 0; 

% 66-100
Z6 = 2.9221; 
fs6 = 0; 
T6 = 510; 
D6 = 0; 

%% [0 100]

% 0-100
Z7 = 2.4424; 
fs7 = 0; 
T7 = 2000; 
D7 = 39.56; 

%% [100 0]

% 100-0
Z8 = 2.5665 
fs8 = 0; 
T8 = 2000; 
D8 = 39.56; 
%% pokracovanie

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

% dalej nepodstatne

 %%
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


%%
load('example__23_03_24_11_13_37_[25,50,75,100].mat', 'all_temperatures');
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


%%
load('example__24_03_24_03_02_57_[66, 33, 0].mat', 'all_temperatures');
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




