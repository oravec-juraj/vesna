% ESP: Constructs an object for ESP device.
%
% my_esp = ESP('PORT') creates an object instance that 
% represents a ESP device. The PORT is mandatory parameter.
% To determine a PORT number, see device manager in Windows or
% /dev/* location on Linux/Mac.
%
% Possible names for PORT files on Linux/Mac:
%        
%     /dev/ttyACMx            (x - is usually 0)
%     /dev/ttyUSBx            (x - is usually 0)
%     /dev/tty.usbserial-x    (x - is a character string)
%
% Example:
%      
%      my_flexy_win = ESP('COM10');
%      my_flexy_linux = ESP('/dev/ttyACM0');
%
% ESP class contains the following public methods:
%     
%      <a href="matlab:help ESP.setVerboseModeOnOff">ESP.setVerboseModeOnOff</a>
%      <a href="matlab:help ESP.getTemperatureAir">ESP.getTemperatureAir</a>
%      <a href="matlab:help ESP.getTemperatureSoil">ESP.getTemperatureSoil</a>
%      <a href="matlab:help ESP.getTemperatureRight">ESP.getTemperatureRight</a>
%      <a href="matlab:help ESP.getTemperatureLeft">ESP.getTemperatureLeft</a>
%      <a href="matlab:help ESP.getLight">ESP.getLight</a>
%      <a href="matlab:help ESP.off">ESP.off</a>
%      <a href="matlab:help ESP.close">ESP.close</a>
%
% Description of each method can be displayed using
%
%        help ESP.[method name]
%


classdef ESP < handle
  
   properties(SetAccess=public)
        SerialObj                   % stores active serial object
        LastIncommingMessage        % last message from experiment
        VerboseMode
        TemperatureTop
        TemperatureBottom
        TemperatureRight
        TemperatureLeft
        Light
        Pressure
        HumidityRight
        HumidityLeft
   end
    
   properties(SetAccess=public)
        Port                        % Port
        SerialStatus                % Status of serial connection
   end
   
   properties(Constant)
        COM_BAUD_RATE = 115200      % fixed baud rate for usb-serial
   end
   
   methods(Access=public)
        
       function obj = ESP(varargin)
            % ESP constructor method
            if(length(varargin)==1)
               port = varargin{1};
               obj.Port = port;
            elseif(isempty(varargin))
               obj.findComPort();
            else
               error('Too many input arguments.'); 
            end
            obj.SerialStatus = 'Closed'; 
            obj.VerboseMode = 0;
            obj.initSerialObject(obj.Port);
            obj.serialConnect();
       end
       
       function setTemp(obj, perc)
        fprintf(obj.SerialObj,'{"LED":0,"FAN":0,"HEATER":%d}',perc)
       end
       
       function setLed(obj, perc)
        fprintf(obj.SerialObj,'{"LED":%d,"FAN":0,"HEATER":0}',perc)
       end
       
       function setFan(obj, perc)
        fprintf(obj.SerialObj,'{"LED":0,"FAN":%d,"HEATER":0}',perc)
       end
       
       function setVerboseModeOnOff(obj,opt)
            % ESP.setVerboseModeOnOff(OPT) for binary value OPT (0-off,
            % 1-on) turns off/on the console output of background serial
            % communication between ESP and MATLAB
          	if(opt==1)
                obj.VerboseMode = 1;
            elseif(opt==0)
                obj.VerboseMode = 0;
            else
               warning('ESPWarning:UnexpectedValueWarning',...
                       ['setVerboseModeOnOff function expects ',...
                       'logical value (either 0 or 1)']); 
            end  
       end
       
       function setActuators(obj,led,fan,heater)
            led = min(max(led, 0), 100);
            fan = min(max(fan, 0), 100);
            heater = min(max(heater, 0), 100);
            fprintf(obj.SerialObj,'{"LED":%d,"FAN":%d,"HEATER":%d}', ...
                    [led,fan,heater]);
       end

       function out = getTemperatureTop(obj)
            % ESP.getTemperatureAir() returns the temperature of the soil.
            out = obj.TemperatureTop;
       end

       function out = getTemperatureBottom(obj)
            % ESP.getTemperatureSoil() returns the light conditions.
            out = obj.TemperatureBottom;
       end

       function out = getTemperatureRight(obj)
            % ESP.getTemperatureRight() returns the the temperature of the
            % air.
            out = obj.TemperatureRight;
       end

       function out = getTemperatureLeft(obj)
            % ESP.getTemperatureLeft() returns the atmospheric pressure.
            out = obj.TemperatureLeft;
       end

       function out = getLight(obj)
            % ESP.getLight() returns the airs humidity.
            out = obj.Light;
       end
       
       function connect(obj)
            obj.serialConnect();
       end
       
       function close(obj)
            % ESP.close closes active connection
            % This must be done before the class object is deleted 
            % or a new one is created.
            obj.serialClose();
       end
       
       function setPort(obj, port)
            obj.Port = port;
       end

       function FlushESP(obj)
            flushinput(obj.SerialObj);
       end
       
   end
   
   methods(Static)

   end
   
   methods(Access=private)

       function findComPort(obj)
           vdate = version('-date');
           release_year = str2double(vdate(end-3:end));
           if(ispc||ismac&&release_year>=2017)
               ports = serialportlist;
               disp('Searching COM ports ...')
               for i=1:length(ports)
                  if contains(ports{i}, {'usb','COM'})
                      ser = serial(ports{i});
                      set(ser,'BaudRate', obj.COM_BAUD_RATE);
                      set(ser,'Terminator',{'CR/LF',''});
                      set(ser, 'TimeOut', 0.1);
                      warning('off','all');
                      fopen(ser);
                      pause(10);
                      message = fscanf(ser,'%s');
                      obj.Port = ports{i};
                      if(~isempty(message))
                          disp([message ' found on port ' ports{i}]);
                          fclose(ser);
                          delete(ser);
                          break;
                      end
                      fclose(ser);
                      delete(ser);
                  end
               end
               if isempty(message)
                  error('No ESP device found.');
               end
           else
               error(['Specification of com. port is required. '...
                      'See <a href="matlab:help ESP">help ESP</a> '...
                      'for more information.'])
           end
       end

       function getIncommingMessage(obj)
            % Parsing function for incomming messages
            %message = fscanf(obj.SerialObj,'%s');
            message = fgetl(obj.SerialObj);
            if message
                %TODO: Finish variable number of sensors implementation.
                % Requires automatic creation of properties based on tags and
                % assignment in the loop or save into the structure.
                data = str2double(regexp(message, '(?<=:|,)\d+\.?\d*','match'));
                tags = regexp(message, '(?<=")\w*(?=")','match');
                
                obj.TemperatureTop = data(1);
                obj.TemperatureBottom = data(2);
                obj.TemperatureRight = data(3);
                obj.TemperatureLeft = data(4);
                obj.Light = data(5);
                obj.Pressure = data(6);
                obj.HumidityRight = data(7);
                obj.HumidityLeft = data(8);
            end

            if obj.VerboseMode
                disp(message);
            end
            obj.LastIncommingMessage = message;
       end
       
       function initSerialObject(obj, com_port)
            % Initiates serial object
            obj.Port = com_port;
            obj.SerialObj = serial(com_port);
            set(obj.SerialObj,'BaudRate', obj.COM_BAUD_RATE);
            set(obj.SerialObj,'Terminator',{'CR/LF',''});
            obj.SerialObj.BytesAvailableFcnMode = 'terminator';
            obj.SerialObj.BytesAvailableFcn = @(~,evt)obj.getIncommingMessage();
            
            %TODO: Transfer to serialport in futuru release.
            %obj.SerialObj = serialport(com_port, obj.COM_BAUD_RATE);
            %configureTerminator(obj.SerialObj, 'CR/LF');
            %configureCallback(obj.SerialObj, 'terminator',...
            % @(~,evt)obj.getIncommingMessage())
       end
        

       function serialConnect(obj)
            % Establishes connection via serial interface
            % this will reset the MCU, so we need to wait a while
            fopen(obj.SerialObj); 
            disp('Waiting for connection ...');
            pause(10);
            if(strcmp(obj.SerialObj.status,'open'))
                obj.SerialStatus = 'Open';
                disp('Connection established.')   
            else
                error('ESPError:SerialConnectError',...
                      ['Could not establish the serial connection.\n',...
                      '%s port may be missing or used by other program.'],...
                      obj.Port);    
            end
       end
       
       function serialClose(obj)
            % Closes serial connection
            fclose(obj.SerialObj);
            obj.SerialStatus = 'Closed';
            disp('Connection closed.');
       end
        
    end
    
end