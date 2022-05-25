current_time = datetime('now')
t_h = [current_time.Hour]
t_min = [current_time.Minute]
light_on = [255]
light_off = [0]
options.RequestMethod = 'auto';
light = webread("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{d6653286-1d51-49d0-83b9-0dd6bf6b54fe}",options)
intensity_of_light = light.last_value


%%
%if t > 20
%    reconnect
%    propertyValue = struct('value',light_on);
%    options.RequestMethod = 'put';
%    light = webwrite("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{128d9d60-0c2f-4a58-a3e4-fb833e10bf81}/publish",propertyValue,options);
%    else if t < 20
%        reconnect
%        propertyValue = struct('value',light_off);
%        options.RequestMethod = 'put';
%        light = webwrite("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{128d9d60-0c2f-4a58-a3e4-fb833e10bf81}/publish",propertyValue,options);
%    end
%end 

%% relativne funkcne 


while(true)
    if t_h > 6 & t_min > 0 & t_h < 20
        reconnect
        if intensity_of_light > 1300
            propertyValue = struct('value',light_off);
            options.RequestMethod = 'put';
            lighting = webwrite("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{128d9d60-0c2f-4a58-a3e4-fb833e10bf81}/publish",propertyValue,options);
        else if intensity_of_light < 1300
                propertyValue = struct('value',light_on);
                options.RequestMethod = 'put';
                lighting = webwrite("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{128d9d60-0c2f-4a58-a3e4-fb833e10bf81}/publish",propertyValue,options);
        end
        end
    else if t_h > 20 & t_min > 0
            reconnect
            propertyValue = struct('value',light_off);
            options.RequestMethod = 'put';
            lighting = webwrite("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{128d9d60-0c2f-4a58-a3e4-fb833e10bf81}/publish",propertyValue,options);
        end
    end
    pause(60)
    else 
        break
end


    