%Control script of all action members in the greenhouse also with sending notifications

reconnect
options.RequestMethod = 'auto';

light_on = 255;
light_off = 0;

T_max = 31;
fans_off = 0;
fans_on = 255;
count = 0;

h_max = 42;
h_min = 38;
hum_off = 0;
hum_on = 255;
propertyValue_h = struct('value',hum_off);


w = 29;
t_top = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{61e6a028-5d0d-4ae5-9684-069fed62d784}",options);
T_top = t_top.last_value;
t_bot = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{68f17374-437c-466d-a7fc-b9b5906002b1}",options);
T_bot = t_bot.last_value;
T_avg = (T_top+T_bot)/2;
e =  w-T_top;
e_p = 0;
u_p = 0;

while(true)
    options.RequestMethod = 'auto';
    %Api connection verification
    try
        door = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{67e83f0d-524f-433b-b478-51a5275040af}",options);
    catch
        reconnect
        door = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{67e83f0d-524f-433b-b478-51a5275040af}",options);
    end    
    door_act = door.last_value;
    % find out the current time 
    current_time = datetime('now');
    t_h = [current_time.Hour];
    t_min = [current_time.Minute];
    %lighting control
    options.RequestMethod = 'auto';
    light = webread("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{d6653286-1d51-49d0-83b9-0dd6bf6b54fe}",options);
    intensity_of_light = light.last_value;
    if t_h >= 6 & t_min > 0 & t_h < 20
        if intensity_of_light > 1500
            propertyValue = struct('value',light_off);
        elseif intensity_of_light < 1500
                propertyValue = struct('value',light_on);
        end
        options.RequestMethod = 'put';
        webwrite("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{128d9d60-0c2f-4a58-a3e4-fb833e10bf81}/publish",propertyValue,options);
    else
        propertyValue = struct('value',light_off);
        options.RequestMethod = 'put';
        webwrite("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{128d9d60-0c2f-4a58-a3e4-fb833e10bf81}/publish",propertyValue,options);
    end

    % ensuring that only the light is controlled when the door is open
    if door_act == 1
        u = 0;
        propertyValue = struct('value', u);
        options.RequestMethod = 'put';
        heat = webwrite("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{a9f0e988-ad3d-4d77-b0aa-a82abfc70c58}/publish",propertyValue, options);
        
        propertyValue_h = struct('value',hum_off);
        options.RequestMethod = 'put';
        webwrite("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{f3fc0564-a623-43d7-a288-fc17a4f25dce}/publish",propertyValue_h,options);
        
        propertyValue = struct('value',fans_off)
        options.RequestMethod = 'put';
        webwrite("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{0c8a7441-7894-4d36-b4ec-7df63dfebd2a}/publish",propertyValue,options);

        if u == 0 && ~sended
            % Notifikácia
            source = 'Vesna.STU.2021@gmail.com';              % email odosielatela
            destination = 'peter.bakarac@stuba.sk';              %email prijímateľa
            myEmailPassword = 'Sklenik2022';                  % heslo od emailovej schránky odosielateľa
            subj = 'Problem with Vesna!';  % Predmet emailu
            msg = 'Hi, Vesna has problem. The door is open, please check it and if it is possible close them.';     % správa
            %set up SMTP pre Gmail
            setpref('Internet','E_mail',source);
            setpref('Internet','SMTP_Server','smtp.gmail.com');
            setpref('Internet','SMTP_Username',source);
            setpref('Internet','SMTP_Password',myEmailPassword);
            % Gmail server
            props = java.lang.System.getProperties;
            props.setProperty('mail.smtp.auth','true');
            props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
            props.setProperty('mail.smtp.socketFactory.port','465');
            % samotné poslanie
            sendmail(destination,subj,msg);
            sended = 1;
        end

        continue
    end
    % temperature control
    count = count + 1;
    options.RequestMethod = 'auto';
    t_top = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{61e6a028-5d0d-4ae5-9684-069fed62d784}",options);
    T_top = t_top.last_value;
    t_bot = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{68f17374-437c-466d-a7fc-b9b5906002b1}",options);
    T_bot = t_bot.last_value;
    T_avg = (T_top+T_bot)/2;
    if t_h >= 6 & t_h < 20
        w = 29;
    else 
        w = 26.5;
    end

    e =  w-T_avg;

    [u] = PID(e,e_p,u_p);

    if u > 255
        u = 255;
    end
    if u < 0 
        u = 0;
    end 
    u_p = u
    e_p = e
    propertyValue = struct('value', u);
    options.RequestMethod = 'put';
    heat = webwrite("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{a9f0e988-ad3d-4d77-b0aa-a82abfc70c58}/publish",propertyValue, options);
    % irrigation management
    try
        hum_bme = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{3b3eccfa-bce9-40d5-a187-a82b75bf300d}",options);
    catch
        reconnect
        hum_bme = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{3b3eccfa-bce9-40d5-a187-a82b75bf300d}",options);
    end
    HUM_bme = hum_bme.last_value;
    hum_dht = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{d69a1c3a-0e1f-4461-bc76-727c68e2b4d3}",options);

    HUM_dht = hum_dht.last_value;
    HUM_avg = HUM_dht;

    if HUM_avg >= h_max
       propertyValue_h = struct('value',hum_off);
    elseif HUM_avg <= h_min
       propertyValue_h = struct('value',hum_on);
    end
    options.RequestMethod = 'put';
    webwrite("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{f3fc0564-a623-43d7-a288-fc17a4f25dce}/publish",propertyValue_h,options);
   
    %  fans control
    if T_avg >= T_max
        propertyValue = struct('value',fans_on);
        options.RequestMethod = 'put';
        count = 0;
    else
        propertyValue = struct('value',fans_off);
        options.RequestMethod = 'put';
    end
    if count >= 120
        propertyValue = struct('value',fans_on);
        options.RequestMethod = 'put';
        if count == 135
            count = 0;
        end
    end
    webwrite("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{0c8a7441-7894-4d36-b4ec-7df63dfebd2a}/publish",propertyValue,options);

    pause(60)

    options.RequestMethod = 'auto';
    try
        fans = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{0c8a7441-7894-4d36-b4ec-7df63dfebd2a}",options);
    catch
        reconnect
        fans = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{0c8a7441-7894-4d36-b4ec-7df63dfebd2a}",options);
    end
        
    fans_act = fans.last_value;

    if T_avg >= T_max & fans_act == 0 
        source = 'Vesna.STU.2021@gmail.com';                % email odosielatela
        destination = 'peter.bakarac@stuba.sk';             %email prijímateľa
        myEmailPassword = 'Sklenik2022';                    % heslo od emailovej schránky odosielateľa
        subj = 'Problem with Vesna!';                       % Predmet emailu
        msg = 'Hi, Vesna has problem with fans.';           % správa
        set up SMTP pre Gmail
        setpref('Internet','E_mail',source);
        setpref('Internet','SMTP_Server','smtp.gmail.com');
        setpref('Internet','SMTP_Username',source);
        setpref('Internet','SMTP_Password',myEmailPassword);
        % Gmail server
        props = java.lang.System.getProperties;
        props.setProperty('mail.smtp.auth','true');
        props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
        props.setProperty('mail.smtp.socketFactory.port','465');
        % samotné poslanie
        sendmail(destination,subj,msg);
    end

    options.RequestMethod = 'auto';
    humidser = webread("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{f3fc0564-a623-43d7-a288-fc17a4f25dce}",options);
    hum_act = humidser.last_value;

    if hum_act == 255 & HUM_avg(t_min == i) == HUM_avg(t_min == i + 10) % dalsia moznost
        source = 'Vesna.STU.2021@gmail.com';              % email odosielatela
        destination = 'peter.bakarac@stuba.sk';           % email prijímateľa
        myEmailPassword = 'Sklenik2022';                  % heslo od emailovej schránky odosielateľa
        subj = 'Problem with Vesna!';                     % Predmet emailu
        msg = 'Hi, Vesna has problem with humidity. Irrigation is on but idle. Please check the level in the fluid reservoir';     % správa
        %set up SMTP pre Gmail
        setpref('Internet','E_mail',source);
        setpref('Internet','SMTP_Server','smtp.gmail.com');
        setpref('Internet','SMTP_Username',source);
        setpref('Internet','SMTP_Password',myEmailPassword);
        % Gmail server
        props = java.lang.System.getProperties;
        props.setProperty('mail.smtp.auth','true');
        props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
        props.setProperty('mail.smtp.socketFactory.port','465');
        % samotné poslanie
        sendmail(destination,subj,msg);
    end

    options.RequestMethod = 'auto';
    lighting = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{128d9d60-0c2f-4a58-a3e4-fb833e10bf81}",options);
    lighting_act = lighting.last_value;
    if lighting_act == 0 && t_h >= 6 && t_min > 0 && t_h < 20 && intensity_of_light < 1500
    % Notifikácia
        source = 'Vesna.STU.2021@gmail.com';              % email odosielatela
        destination = 'peter.bakarac@stuba.sk';              %email prijímateľa
        myEmailPassword = 'Sklenik2022';                  % heslo od emailovej schránky odosielateľa
        subj = 'Problem with lighting!';  % Predmet emailu
        msg = 'Hi, Vesna has problem. The light values are too low and the light is turned off, please check the condition of the greenhouse.';     % správa
        %set up SMTP pre Gmail
        setpref('Internet','E_mail',source);
        setpref('Internet','SMTP_Server','smtp.gmail.com');
        setpref('Internet','SMTP_Username',source);
        setpref('Internet','SMTP_Password',myEmailPassword);
        % Gmail server
        props = java.lang.System.getProperties;
        props.setProperty('mail.smtp.auth','true');
        props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
        props.setProperty('mail.smtp.socketFactory.port','465');
        % samotné poslanie
        sendmail(destination,subj,msg);
    end
    if t_h < 6 & t_min > 0 & t_h >= 20 & lighting_act == 255
        % Notifikácia
        source = 'Vesna.STU.2021@gmail.com';              % email odosielatela
        destination = 'peter.bakarac@stuba.sk';              %email prijímateľa
        myEmailPassword = 'Sklenik2022';                  % heslo od emailovej schránky odosielateľa
        subj = 'Problem with lighting!';  % Predmet emailu
        msg = 'Hi, Vesna has problem. The light is turned on, but it should not. Please check the condition of the greenhouse.';     % správa
        %set up SMTP pre Gmail
        setpref('Internet','E_mail',source);
        setpref('Internet','SMTP_Server','smtp.gmail.com');
        setpref('Internet','SMTP_Username',source);
        setpref('Internet','SMTP_Password',myEmailPassword);
        % Gmail server
        props = java.lang.System.getProperties;
        props.setProperty('mail.smtp.auth','true');
        props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
        props.setProperty('mail.smtp.socketFactory.port','465');
        % samotné poslanie
        sendmail(destination,subj,msg);
    end

end
