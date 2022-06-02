%A PI controller is used to control the temperature, whose task is to control the temperature to a certain setpoint.


reconnect
%Setting of temperature setpoint, control deviation and control signal
w = 28;
options.RequestMethod = 'auto';
t_top = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{61e6a028-5d0d-4ae5-9684-069fed62d784}",options);
T_top = t_top.last_value;
t_bot = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{68f17374-437c-466d-a7fc-b9b5906002b1}",options);
T_bot = t_bot.last_value;
T_avg = (T_top+T_bot)/2;
e =  w-T_top;
e_p = 0;
u_p = 0;


%%
while(true)
    %Api connection verification
    try
        t_top = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{61e6a028-5d0d-4ae5-9684-069fed62d784}",options);
    catch
        reconnect
        t_top = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{61e6a028-5d0d-4ae5-9684-069fed62d784}",options);
    end
    T_top = t_top.last_value;
    t_bot = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{68f17374-437c-466d-a7fc-b9b5906002b1}",options);
    T_bot = t_bot.last_value;
    T_avg = (T_top+T_bot)/2;
    % Calculation of the deviation from the setpoint
    e =  w-T_avg;
    % PI controller function
    [u] = PID(e,e_p,u_p);
    % treatment of deviation from the interval 0-255 of the control variable
    if u > 255
        u = 255;
    end
    if u < 0 
        u = 0;
    end 
    u_p = u
    e_p = e
    %sending a signal about the control variable
    propertyValue = struct('value', u);
    options.RequestMethod = 'put';
    heat = webwrite("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{a9f0e988-ad3d-4d77-b0aa-a82abfc70c58}/publish",propertyValue, options);
    pause(60)
end


