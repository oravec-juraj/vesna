% Task of humidifier is to ensure that humidity does not fall below the
% specified humidity limit. At this value, the humidifier switches on.
% Humidifier is controled by on/off control.

% Set up the values of humufity, when the humidifier switches on/off.
h_max = 42;
h_min = 38;
options.RequestMethod = 'auto';
% Defining the power of fans at on and off 
hum_off = 0;
hum_on = 255;

while(true)
    %Api connection verification
    try
        hum_bme = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{3b3eccfa-bce9-40d5-a187-a82b75bf300d}",options);
    catch
        reconnect
        hum_bme = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{3b3eccfa-bce9-40d5-a187-a82b75bf300d}",options);
    end
    HUM_bme = hum_bme.last_value;

    % Calculation of the current average humidity 
    hum_dht = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{d69a1c3a-0e1f-4461-bc76-727c68e2b4d3}",options);
    HUM_dht = hum_dht.last_value;
    HUM_avg = (HUM_dht+HUM_bme)/2;
    
    % Switching the humidifier on/off at the set humidity values
    if HUM_avg > h_min
        propertyValue = struct('value',hum_off);
        options.RequestMethod = 'put';
    elseif HUM_avg < h_max 
        propertyValue = struct('value',hum_off);
        options.RequestMethod = 'put';
    else
        propertyValue = struct('value',hum_on);
        options.RequestMethod = 'put';
    end
    webwrite("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{f3fc0564-a623-43d7-a288-fc17a4f25dce}/publish",propertyValue,options);
    pause(60)
end