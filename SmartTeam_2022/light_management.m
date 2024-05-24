light_on = [255]  %
light_off = [0]   %

while(true)
    %detection of the current time
    current_time = datetime('now');
    t_h = [current_time.Hour];
    t_min = [current_time.Minute];
    options.RequestMethod = 'auto';
    try
        light = webread("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{d6653286-1d51-49d0-83b9-0dd6bf6b54fe}",options);
    catch
        reconnect  %runs the API 
        light = webread("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{d6653286-1d51-49d0-83b9-0dd6bf6b54fe}",options);
    end
    intensity_of_light = light.last_value;
    if t_h >= 6 & t_min > 0 & t_h < 20       %verification whether the current time is in the time interval 
        if intensity_of_light > 1500         %if the value of the intensity of light is greater than 1500, light turns off
            propertyValue = struct('value',light_off);
        elseif intensity_of_light < 1500     %if the value of the intensity of light is less than 1500, light turns on
            propertyValue = struct('value',light_on);
        end
        options.RequestMethod = 'put'; 
        lighting = webwrite("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{128d9d60-0c2f-4a58-a3e4-fb833e10bf81}/publish",propertyValue,options);
    else
        %if the current time is not in the time interval, light is off
        propertyValue = struct('value',light_off);
        options.RequestMethod = 'put';
        lighting = webwrite("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{128d9d60-0c2f-4a58-a3e4-fb833e10bf81}/publish",propertyValue,options);
    end
    pause(60)
end