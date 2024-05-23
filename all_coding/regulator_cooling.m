%% naslinova metoda na vypocet PI regulatora
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
% pre zvolene max preregulovanie 1% >> alfa = 2.4
% aj^2 = alfa*a(j+1)*a(j-1) = 0
% (1 + 0.0086*Zr) = 2.4 * 1980.6 * 0.0086*Zr/Ti

% teraz zvolime Zr = napr. 10 a doratame Ti
Zr = 50;
Ti = (2.4 * 1980.6 * 0.0086*Zr)/(1 + 0.0086*Zr)

Ti_10 = 376.4234;
Ti_30 = 974.8708;
Ti_50 = 1.4294e+03;

%% using the PI in action to determine its quality
%% this differs when working with input that can only increase or only decrese the temperature.
%% in this particular section, the humidiser can only decrease the temperature
% Connect to Arduino IoT Cloud
run('vesna_credentials_json.m'); % nacitanie do workspacu url, username, password
vesna = vesna;
vesna.connect(url,login,password);
flag = vesna.communication.flag;

% Set desired temperature
desiredTemperature = 25.9; % Example: 25 degrees Celsius

% Initialize PI controller parameters for humidifier
Kp_humid = 50; % P
Ki_humid = 1.4294e+03; % 313.6862; % I
integralTerm_humid = 0;

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
    humidifierValue = data.humidiser.value;
    
    % Calculate error
    error_temp = desiredTemperature - currentTemperature;
    
    % Humidifier Control (directly affecting temperature)
    if currentTemperature < desiredTemperature && humidifierValue == 0
        disp('Cannot increase temperature with humidifier at 0.');
    else
        controlSignal_humid = Kp_humid * error_temp - Ki_humid * error_temp;
        disp(['Control Signal to Humidifier before: ', num2str(round(controlSignal_humid))]);

        % the commented out section is not needed. without it, the
        % temperature is hoovering around 1% above or below the desired
        % value. with it, it is hoovering around the exact desired
        % temperature. but it is still extra precised. 
        % scaling_factor = 100.0 / max(1, abs(controlSignal_humid));
        % controlSignal_humid = controlSignal_humid * scaling_factor;

        controlSignal_humid = max(0, min(100, controlSignal_humid));
        disp(['Control Signal to Humidifier po: ', num2str(round(controlSignal_humid))]);

        % Send control signal to humidifier through IoT Cloud
        vesna.upload("humidiser", round(controlSignal_humid)); % Round to integer

    end
    % Store data for plotting
    time(end+1) = now; % append current time
    temperature(end+1) = currentTemperature;
    control_signal(end+1) = controlSignal_humid;    
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
    pause(10); 
end
