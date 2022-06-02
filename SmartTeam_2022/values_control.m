control_values = [0, 100, 255, 150, 20, 0];   %controlled values  
my_time_dur= [1200, 5400, 5400, 5400, 5400, 5400]; %duration of each of controlled values in seconds 

options.RequestMethod = 'auto';
for x = [1:length(control_values)]
    reconnect
    fprintf('Setting new value %d\n', control_values(x))
   % implementation of the controlled values in the API
    fans = webread("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{0c8a7441-7894-4d36-b4ec-7df63dfebd2a}",options)
    propertyValue = struct('value',control_values(x)); %rewrites property values
    options.RequestMethod = 'put';
    fans = webwrite("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{0c8a7441-7894-4d36-b4ec-7df63dfebd2a}/publish",propertyValue,options);
    pause(my_time_dur(x));
   
end

