%% naslinova metoda
% Gs - system, Gr - regulator
Z = 0.0086;
T = 1980.6;
D = 146.7; % zanedbame
% Gs = Z/(T*s+1);

% max preregulovanie: 20  | 12  | 8   | 5   | 3   | 1
% alfa:               1.7 | 1.8 | 1.9 | 2.0 | 2.2 | 2.4
% PI/PID stupeň CHR URO = rád systému Gs + 1
rad = 1+1;
% CHR URO n-tého rádu vedie na sústavu n-1 rovníc.
% pocet Naslinovych rovnic = rad - 1 = 2-1 = 1
% PI regulátor: 1 rovnica a 2 neznáme → 1 sa zvolí a 2. sa vypočíta

% chr uro >> 1 + Gs*Gr = 0
% 1 + 0.0086/(1980.6*s + 1)* [(Zr*s + Zr/Ti)/s] = 0
% 1980.6*s^2 + (1+0.0086*Zr)*s + 0.0086*Zr/Ti = 0
% pre zvolene max preregulovanie 5% >> alfa = 2.0
% aj^2 = alfa*a(j+1)*a(j-1) = 0
% (1 + 0.0086*Zr) = 2 * 1980.6 * 0.0086*Zr/Ti

% teraz zvolime Zr = napr. 10 a doratame Ti
Zr = 30;
Ti = (2 * 1980.6 * 0.0086*Zr)/(1 + 0.0086*Zr)

Ti_10 = 313.6862;
Ti_30 = 812.3924;

%% using the PI in action
% Connect to Arduino IoT Cloud
run('vesna_credentials_json.m'); % nacitanie do workspacu url, username, password
vesna = vesna;
vesna.connect(url,login,password);
flag = vesna.communication.flag;

% Set desired temperature
desiredTemperature = 28.7; % Example: 25 degrees Celsius

% Initialize PI controller parameters for humidifier
Kp_heater = 20.5952; 
Ki_heater = 199.99999; 
integralTerm_heater = 0;

% Initialize arrays for plotting
time = [];
temperature = [];
control_signal = [];
desired_temperature = [];

% Initialize plot
figure;
hold on;

while true
    vesna.reconnect;


    % Read current temperature from IoT Cloud
    data = vesna.download();
    currentTemperature = data.temperature.value;
    heaterValue = data.heater.value;
    
    % Calculate error
    error_temp =  currentTemperature - desiredTemperature;

    % Update integral term
    %integralTerm_heater = integralTerm_heater + error_temp;
    
    % Humidifier Control (directly affecting temperature)
    if currentTemperature > desiredTemperature && heaterValue == 100
        %disp('Cannot dicrease temperature with heater at 100.');
        % Send control signal to humidifier through IoT Cloud
        vesna.upload("heater", 0); % Round to integer

        % Display values sent to the humidifier
        disp(['Control Signal to Heater: ', num2str(round(controlSignal_heater_3))]);
    else
        controlSignal_heater_1 = Kp_heater * error_temp - Ki_heater * error_temp; %za druhe error_temp bolo integralTerm_heater
        %controlSignal_heater_1 - treba menit to znamienko jak Miska pisala aby to workovalo
        scaling_factor = 100.0 / max(1, abs(controlSignal_heater_1));

        controlSignal_heater_2 = controlSignal_heater_1 * scaling_factor;
        controlSignal_heater_3 = max(0, min(100, controlSignal_heater_2));

        % Send control signal to humidifier through IoT Cloud
        vesna.upload("heater", round(controlSignal_heater_3)); % Round to integer

        % Display values sent to the humidifier
        disp(['Control Signal to Heater: ', num2str(round(controlSignal_heater_3))]);
    end
    % Store data for plotting
    time(end+1) = now; % append current time
    temperature(end+1) = currentTemperature;
    control_signal(end+1) = controlSignal_heater_3;
    desired_temperature(end+1) = desiredTemperature;
    
    % Plot temperature and control signal over time
    plot(time, temperature, 'b', 'LineWidth', 2); % plot temperature in blue
    plot(time, desired_temperature, 'r--', 'LineWidth', 1.5); % plot desired temperature as dashed red line
    xlabel('Time');
    ylabel('Temperature (°C)');
    title('Temperature Control System');
    legend('Actual Temperature', 'Desired Temperature');
    grid on;
    
    % Pause for a certain time before next iteration
    pause(10); % Example: 5 seconds
end
