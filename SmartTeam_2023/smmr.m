
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% SMMR
%
% File for summarization of Vesna data for the last day. M-file consists of
% a function that provides the ID value, which indicates whether
% summarization data was/wasn't already sent. It requires a series of
% input data for current Vesna status. Once the night-time control time
% occurs, a summarization mail is sent to the user.
%
% List of used functions
%   credentials2  - loads e-mail credentials
%   errors        - checks the type of error that occurred
%
% List of input variables
%   door_val      - door opening position
%   fan_S         - fan control input
%   h_max         - maximum preferred humidity
%   h_min         - minimum preferred humidity
%   HUM_bme       - humidity (BME680 sensor)
%   HUM_dht       - humidity (DHT11 sensor)
%   hum_S         - humidity control input
%   id            - identifier of the emerged e-mail
%   irr_S         - irrigation control input
%   light_int     - minimum preferred light intensity
%   light_S       - lighting control input
%   light_val     - light intensity
%   samp          - sampling period
%   soil_hum      - soil humidity
%   t_d           - derivative gain
%   t_h           - current time hour
%   t_i           - integral gain
%   time_down     - daytime control start
%   time_up       - night-time control start
%   T_bot         - temperature (top of the greenhouse)
%   temp_S        - temperature control input
%   t_max         - maximum preferred temperature
%   T_top         - temperature (bottom of the greenhouse)
%   vent_dur      - ventilation duration
%   vent_start    - ventilation period
%   w_day         - daytime temperature setpoint
%   z_r           - proportional gain
%
% List of output variables
%   id            - identifier of the emerged e-mail
%
% List of local variables
%   data          - e-mail body text
%   data_C        - user e-mail credentials
%   destin        - recipient's e-mail address
%   fileID        - loaded file ID
%   msg           - description of the sent data (e-mail message)
%   password      - sender's password
%   source        - sender's e-mail address
%   spec          - e-mail send attempts
%   subj          - type of the send data (e-mail subject)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function id = smmr(id,t_h,time_down,time_up,light_int,t_max,w_day, ...
    w_night,h_max,h_min,samp,vent_start,vent_dur,door_val,light_val, ...
    T_top,T_bot,HUM_bme,HUM_dht,z_r,t_i,t_d,temp_S,fan_S,hum_S,light_S, ...
    soil_hum,irr_S)

% Send email Y/N
if id == 0 && time_up <= time2num(t_h)
    id = 1;
elseif id == 1 && time_up <= time2num(t_h)
    id = 2;
elseif id == 2 && time_up > time2num(t_h)
    id = 0;
end

if id == 1

% Load Gmail credentials
data_C = credentials2;

source = data_C{1};
destin = data_C{2};
password = data_C{3};

% Set Gmail SMTP
setpref('Internet','E_mail',source);
setpref('Internet','SMTP_Server','smtp.gmail.com');
setpref('Internet','SMTP_Username',source);
setpref('Internet','SMTP_Password',password);

% Gmail server
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.starttls.enable', 'true' );
props.setProperty('mail.smtp.socketFactory.port','465');

% Message description
fileID = fopen('smmr.txt','r');
data = strrep(split(fscanf(fileID,'%s'),';'),'_',' ');
fclose(fileID);

if door_val == 0
    door_val = 'Closed';
elseif door_val == 1
    door_val = 'Open';
end
if fan_S == 0
    fan_S = 'Turned off';
elseif fan_S == 255
    fan_S = 'Turned on';
end
if hum_S == 0
    hum_S = 'Turned off';
elseif hum_S == 255
    hum_S = 'Turned on';
end
if light_S == 0
    light_S = 'Turned off';
elseif light_S == 255
    light_S = 'Turned on';
end
if irr_S == 0
    irr_S = 'Turned off';
elseif irr_S == 1
    irr_S = 'Turned on';
end

% Construct an e-mail
subj = data{1};
msg = [strcat(data{2},string(datetime('now','Format','dd-MMM-yyyy')),').') ...
    ' ' data{3} ...
    strcat(data{4}," ",string(duration(hours(time_down),'Format','hh:mm:ss'))) ...
    strcat(data{5}," ",string(duration(hours(time_up),'Format','hh:mm:ss'))) ...
    strcat(data{6}," ",string(light_int)) ...
    strcat(data{7}," ",string(t_max),'°C') ...
    strcat(data{8}," ",string(w_day),'°C') ...
    strcat(data{9}," ",string(w_night),'°C') ...
    strcat(data{10}," ",string(h_max),'%') ...
    strcat(data{11}," ",string(h_min),'%') ...
    strcat(data{12}," ",string(samp),'s') ...
    strcat(data{13}," ",string(vent_start),'min') ...
    strcat(data{14}," ",string(vent_dur),'min') ...
    ' ' data{15} ...
    strcat(data{16}," ",string(door_val)) ...
    strcat(data{17}," ",string(light_val)) ...
    strcat(data{18}," ",string(round(T_top,2)),'°C') ...
    strcat(data{19}," ",string(round(T_bot,2)),'°C') ...
    strcat(data{20}," ",string(round(HUM_bme,2)),'%') ...
    strcat(data{21}," ",string(round(HUM_dht,2)),'%') ...
    strcat(data{22}," ",string(round(soil_hum,2)),'%') ...
    ' ' data{23} ...
    strcat(data{24}," ",string(z_r)) ...
    strcat(data{25}," ",string(t_i)) ...
    strcat(data{26}," ",string(t_d)) ...
    strcat(data{27}," ",string(round(temp_S/255*100,2))) ...
    strcat(data{28}," ",fan_S) ...
    strcat(data{29}," ",hum_S) ...
    strcat(data{30}," ",light_S) ...
    strcat(data{31}," ",irr_S)];

% Send notification e-mail
for spec = 1:5
    try
        sendmail(destin,subj,strjoin(msg,'\n'));
        fprintf(strcat('Day data summary was sent to your mail address (', ...
            string(datetime('now')),').\n\n'))
        break
    catch
        pause(5)

        % Terminates after 5 attempts
        if spec == 5
            errors('email',spec);
            break
        end
    end
end
end

end
