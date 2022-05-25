%The main task of the fans is to ensure air exchange in the vesna
%greenhouse and cooling when a maximum temperature limit is exceeded. Fans are controled by on/off control.


% Set up the maximum temperature limit and defining the power of fans at on and off 
T_max = 32;
options.RequestMethod = 'auto';
fans_off = 0;
fans_on = 255;

while(true)
    %Api connection verification
    try
        t_top = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{61e6a028-5d0d-4ae5-9684-069fed62d784}",options);
    catch
        reconnect
        t_top = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{61e6a028-5d0d-4ae5-9684-069fed62d784}",options);
    end
    % Create a variable based on which they will be turned periodically
    count = 0;

    % Calculation of the current average temperature in the greenhouse
    T_top = t_top.last_value;
    t_bot = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{68f17374-437c-466d-a7fc-b9b5906002b1}",options);
    T_bot = t_bot.last_value;
    T_avg = (T_top+T_bot)/2;
    % Switching on the fans when a certain maximum temperature limit is
    % exceeded
    if T_avg >= T_max
        propertyValue = struct('value',fans_on)
        options.RequestMethod = 'put';
        count = 0;
    else
        propertyValue = struct('value',fans_off)
        options.RequestMethod = 'put';
        count = count + 1;
    end
    webwrite("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{0c8a7441-7894-4d36-b4ec-7df63dfebd2a}/publish",propertyValue,options);
    % Switching on the fans in case of their two-hour inactivity
    if count == 10800
        k = 0;
        % Switching on the fans for 15-minutes  
        while k<15
            propertyValue = struct('value',fans_on);
            options.RequestMethod = 'put';
            webwrite("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{0c8a7441-7894-4d36-b4ec-7df63dfebd2a}/publish",propertyValue,options);
            k = k+1;
            pause(60)
        end
        count = 0;
        propertyValue = struct('value',fans_off);
        options.RequestMethod = 'put';
        % Sending on/off setting of fans
        webwrite("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{0c8a7441-7894-4d36-b4ec-7df63dfebd2a}/publish",propertyValue,options);
    end 
    pause(60)
end

