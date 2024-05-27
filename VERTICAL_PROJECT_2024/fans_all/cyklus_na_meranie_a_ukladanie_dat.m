

% VYHLADAJTE SI VSETKY VYSKYTY HUMIDISER A PREHODTE ZA VAMI MERANU VELICINU
clc,clear all
% demo
run('vesna_credentials_json.m'); % nacitanie do workspacu url, username, password
% inicializacia
vesna = vesna;
% connection
vesna.connect(url,login,password);
flag = vesna.communication.flag;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TU SI ZMENITE LEN SKOKOVE ZMENY. VZDY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% IBA JEDNU MOZNOST PLS
% MOZNOST A (ZACINA OD 0)
% target_values = [33, 66, 100]; %16:23 - start, 16:39 - 33, 17:03 - 66, 17:26 - 100
% target_values = [25, 50, 75, 100]; %18:22 - start, 19:47 - 25, 19:51 - 50, 20:04 - 75, 20:45 - 100, 23:49 - end
% target_values = [50, 100]; % 9:28 - start, 9:44 - 50, 10:03 - 100, 10:21 - end
% target_values = [100]; % 10:53 - start, 12:49 - 100, 14:11 - end 
% % MOZNOST B (ZANICA OD 100)
% target_values = [66, 33, 0]; %14:50 - start, 15:57 - 66, 17:20 - 33, 18:22 - 0, 19:32 - end
% target_values = [75, 50, 25, 0]; % 00:46 - start, 2:33 - 75, 2:54 - 50, 3:12 - 25, 4:45 - 0, 4:54 - end
% target_values = [50, 0]; % 22:15 - start, 22:48 - 50, 23:40 - 0, 0:16 - end
 target_values = [0]; % 21:19 - start, 22:57 - 0, 23:24 - end
settled_threshold = 0.001; % 5% threshold for settling
%settled_threshold = 0.05;
settled_window = 20; % Number of consecutive values within threshold for settling
%settled_window = 5;
settled_count = 0;
wait_iterations = 60; % Number of iterations to wait after each increase
%wait_iterations = 5;
settling_periods = []; % Store settling periods

% Set initial fan speed to 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% toto sa meni len ked idete z 0 na 100
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% alebo zo 100 na 0. to je ten initial
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% point 
%vesna.upload('fans', 0); % MOZNOST A
vesna.upload('fans', 100); % MOZNOST B


% Initialize arrays to store data and times



all_temperatures = [];
all_times = cell(1, 0); % Initialize as an empty cell array
step_changes = [];

while true
    % Download data
    data = vesna.download();
    temperature = data.temperature.value;

    % Get current time
    current_time = datetime('now');
    
    % Save data and time
    all_temperatures(end+1) = temperature;
    all_times{end+1} = current_time;

    % Display current temperature and time
    disp(['Current Temperature: ' num2str(temperature)]);
    disp(['Current Time: ' datestr(current_time, 'dd.mm.yy HH:MM:SS')]);
    
    % Check if waiting iterations are over
    if wait_iterations > 0
        wait_iterations = wait_iterations - 1;
        disp(['Waiting for ' num2str(wait_iterations) ' iterations before checking settling.']);
    else
        % Check if settled and adjust humidiser accordingly
        if settled_count >= settled_window
            if numel(target_values) > 0
                target_value = target_values(1);
                vesna.upload('fans', target_value);
                % Store the step change
                step_changes(end+1) = target_value;
                % Display fan value change
                disp(['Fans Changed to: ' num2str(target_value)]);
                % Reset settled count only when a new fan speed is uploaded
                settled_count = 0;
                % Estimate settling period and set waiting iterations
                if numel(settling_periods) >= 2
                    settling_period = median(diff(settling_periods));
                    wait_iterations = round(settling_period / 10); % Wait for 10% of the median settling period
                else
                    wait_iterations = 9; % Wait for 10 iterations as the default
                end
                % Remove the applied target value
                target_values(1) = [];
            else
                break; % Stop the loop if no more target values
            end
        end

        % Display settled count
        disp(['Settled Count: ' num2str(settled_count)]);

        % Check if values are settled
        if numel(all_temperatures) >= settled_window
            last_window = all_temperatures(end-settled_window+1:end);
            diff_percentage = abs(diff(last_window)) ./ last_window(1:end-1);
            if all(diff_percentage < settled_threshold)
                settled_count = settled_count + 1;
                if settled_count == 1
                    settling_periods = [settling_periods, 0];
                else
                    settling_periods(end) = settling_periods(end) + 1;
                end
            else
                settled_count = 0;
            end
            % Display diff_percentage
            disp(['Diff Percentage: ' num2str(diff_percentage)]);
        end
    end
    
    % Wait for 10 seconds before the next iteration
    pause(10);
end

% Convert cell array of datetime objects to numerical array
numeric_times = cellfun(@datenum, all_times);

% Find the first and last datetime values
start_time = min(numeric_times);
end_time = max(numeric_times);

% Generate 10 evenly spaced datetimes between the first and last datetime values
evenly_spaced_times = linspace(start_time, end_time, 10);

% Plot temperature data
figure;
plot(numeric_times, all_temperatures, '-');
title('Temperature Variation Over Time');
xlabel('Time');
ylabel('Temperature (°C)');
grid on;

% Adjust x-axis density
datetick('x', 'dd.mm.yy HH:MM:SS', 'KeepLimits'); % Keep original x-axis limits

% Display every third value on the x-axis
xticks(gca, evenly_spaced_times);

% Rotate x-axis tick labels for better readability
xtickangle(45);

% Convert times to a custom format (DD.MM.YY_HH:MM:SS)
formatted_times = datestr(cellfun(@datenum, all_times), 'dd.mm.yy_HH:MM:SS');

% Generate a string representation of target values
target_str = strjoin(arrayfun(@num2str, target_values, 'UniformOutput', false), '_');

% Create the title based on the target values
ulozena_hodnota = ['example_' target_str];

% Get the current date and time
current_datetime = datetime('now', 'Format', 'yyMMdd_HHmmss');

% Create the title based on the target values and current date and time
ulozena_hodnota = ['example_' target_str '_' char(current_datetime)];

% Replace invalid characters in the filename
invalid_chars = {' ', ':', '.'};
for char_replace = invalid_chars
    ulozena_hodnota = strrep(ulozena_hodnota, char_replace{1}, '_');
end

% Save all data
save(ulozena_hodnota, 'all_temperatures', 'all_times', 'step_changes');

% Replace invalid characters in the filename for the plot
plot_filename = ['example_' target_str '_' datestr(now, 'dd.mm.yy_HH.MM.SS')];
for char_replace = invalid_chars
    plot_filename = strrep(plot_filename, char_replace{1}, '_');
end

% Save the plot as an image
saveas(gcf, append(plot_filename, '.png'));

% Close the figure window
close(gcf);
