% Flexy2: Constructs an object for Flexy2 device
%
% my_flexy = Flexy2('PORT') creates an object instance that 
% represents a Flexy2 device. The PORT is mandatory parameter in 
% Linux or Mac, in Windows optional.
% To determine a PORT number, see device manager in Windows or
% /dev/* location on Linux/Mac.
%
% Possible names for PORT files on Linux/Mac:
%        
%       /dev/ttyACMx    (x - is usually 0)
%       /dev/ttyUSBx    (x - is usually 0)
%       /dev/tty.usbserial-x    (x - is a character string)
%
% If device ports are missing, see these tutorials for help with driver installation:
%        https://learn.sparkfun.com/tutorials/how-to-install-ftdi-drivers/linux
%        https://learn.sparkfun.com/tutorials/how-to-install-ftdi-drivers/mac
%
% Example:
%      
%        my_flexy_win = Flexy2('COM10');
%        my_flexy_linux = Flexy2('/dev/ttyACM0');
%
% Flexy2 class contains the following public methods:
%       
%        .setFanSpeedPerc (see <a href="matlab:help Flexy2.setFanSpeedPerc">Flexy2.setFanSpeedPerc</a>)
%        .setInternalSamplingFreq (see <a href="matlab:help Flexy2.setInternalSamplingFreq">Flexy2.setInternalSamplingFreq</a>)
%        .setArtificialNoise (see <a href="matlab:help Flexy2.setArtificialNoise">Flexy2.setArtificialNoise</a>)
%        .setDelaySamples (see <a href="matlab:help Flexy2.setDelaySamples">Flexy2.setDelaySamples</a>)
%        .setFilter (see <a href="matlab:help Flexy2.setFilter">Flexy2.setFilter</a>)
%        .dataFlowOnOff (see <a href="matlab:help Flexy2.dataFlowOnOff">Flexy2.dataFlowOnOff</a>)
%        .setVerboseModeOnOff (see <a href="matlab:help Flexy2.setVerboseModeOnOff">Flexy2.setVerboseModeOnOff</a>)
%        .calibrate (see <a href="matlab:help Flexy2.calibrate">Flexy2.calibrate</a>)
%        .getBendPerc (see <a href="matlab:help Flexy2.getBendPerc">Flexy2.getBendPerc</a>)
%        .getUserInputLPerc (see <a href="matlab:help Flexy2.getUserInputLPerc">Flexy2.getUserInputLPerc</a>)
%        .getUserInputRPerc (see <a href="matlab:help Flexy2.getUserInputRPerc">Flexy2.getUserInputRPerc</a>)
%        .getTerminalInputPerc (see <a href="matlab:help Flexy2.getTerminalInputPerc">Flexy2.getTerminalInputPerc</a>)
%        .off (see <a href="matlab:help Flexy2.off">Flexy2.off</a>)
%        .close(see <a href="matlab:help Flexy2.close">Flexy2.close</a>)
%
% Description of each method can be displayed using
%
%        help Flexy2.[method name]
%
% Brought to you by Optimal Control Labs Ltd.


classdef Flexy2 < handle
  
   properties(SetAccess=public)
        SerialObj                   % stores active serial object
        LastIncommingMessage        % last message from experiment
        VerboseMode
        DataFlow
        BendPerc
        UserInputLPerc
        UserInputRPerc
        TerminalInputPerc
        Version
   end
    
   properties(SetAccess=public)
        ComPort                     % COM port
        SerialStatus                % status of serial connection
   end
   
   properties(Constant)
        COM_BAUD_RATE = 115200      % fixed baud rate for usb-serial
   end
   
   methods(Access=public)
        
       function obj = Flexy2(varargin)
            % Flexy2 constructor method
            if(length(varargin)==1)
               port = varargin{1};
               obj.ComPort = port;
            elseif(isempty(varargin))
               obj.findComPort();
            else
               error('Too many input arguments.'); 
            end
            obj.SerialStatus = 'Closed'; 
            obj.VerboseMode = 0;
            obj.initSerialObject(obj.ComPort);
            obj.serialConnect();
            obj.dataFlowOnOff(1);
            obj.DataFlow = 1;
       end
       
       function setFanSpeedPerc(obj,speed)
           % Flexy2.setFanSpeedPerc(SPEED) sets the speed of the fan on
           % a Flexy2 device. SPEED is in percentage [0-100] of maximum
           % achievable fan speed.
            if(speed>100)
                speed = 100;
            elseif(speed<0)
                speed = 0;
            end
            speedInt = round(speed*2.55);
            fprintf(obj.SerialObj,'<F:%d>',speedInt);
       end
       
       function setInternalSamplingFreq(obj,freq)
            % Flexy2.setInternalSamplingFreq(FREQ) sets the frequency [in Hz] of
            % data update rate from Flexy2 [min: 5, max: 255]
            if(freq>255)
                freq = 255;
            elseif(freq<5)
                freq = 5;
            end
            
            fprintf(obj.SerialObj,'<S:%d>',round(freq));
       end
       
       function dataFlowOnOff(obj,opt)
            % Flexy2.dataFlowOnOff(OPT) for binary value OPT (0-off,
            % 1-on) turns off/on the background serial
            % communication between Flexy2 and MATLAB
            if(opt==1)
                fprintf(obj.SerialObj,'<P:%d>',round(opt));
                obj.DataFlow = 1;
            elseif(opt==0)
                fprintf(obj.SerialObj,'<P:%d>',round(opt));
                obj.DataFlow = 0;
            else
               warning('FlexyWarning:UnexpectedValueWarning', ...
                   ['dataFlowOnOff function expects ' ...
                   'logical value (either 0 or 1)']); 
            end
       end
       
       function setVerboseModeOnOff(obj,opt)
            % Flexy2.setVerboseModeOnOff(OPT) for binary value OPT (0-off,
            % 1-on) turns off/on the console output of background serial
            % communication between Flexy2 and MATLAB
          	if(opt==1)
                obj.VerboseMode = 1;
            elseif(opt==0)
                obj.VerboseMode = 0;
            else
               warning('FlexyWarning:UnexpectedValueWarning', ...
                   ['setVerboseModeOnOff function expects ' ...
                   'logical value (either 0 or 1)']); 
            end  
       end
       
       function setArtificialNoise(obj, mag)
           % Flexy2.setArtificialNoise(MAG) adds randomly distributed artificial noise
           % to the measurements. Noise magnitude MAG is units of [%] of signal range[0-100%].
           % Minimum value 0 represents no artificaial noise (SNR=Inf) and
           % maximum value of 25 represents 25% of noise in signal range (SNR=4);
           mag = round(mag*10);
           if(mag>250)
               warning('FlexyWarning:UnexpectedValueWarning', ...
                   ['setArtificialNoise function expects values between ' ...
                   '0 and 25 - value is being ignored']);
           elseif(mag<0)
               warning('FlexyWarning:UnexpectedValueWarning', ...
                   ['setArtificialNoise function expects values between ' ...
                   '0 and 25 - value is being ignored']);
           else
               fprintf(obj.SerialObj,'<N:%d>',mag);
           end
       end
       
       function setFilter(obj, weight)
           % Flexy2.setFilter(W) initializes a an exponential smoothing
           % filter: y(k) = (1-W)*x(k)+W*x(k-1), where W is a weighting
           % factor between current and previous measurement.
           % Examples:
           %    N = 0       No smoothing (just current measurements)
           %    N = 0.1     Minor smoothing
           %    N = 0.5     Mediate smoothing
           %    N = 0.9     Heavy smoothing
           %    N = 1       Current measurements are lost (this setting is not useful at all)
           
           
           weight = round(weight*100);
           if(weight>100)
               warning('FlexyWarning:UnexpectedValueWarning', ...
                   ['setFilter function expects values between ' ...
                   '0 and 1 - value is being ignored']);
           elseif(weight<0)
               warning('FlexyWarning:UnexpectedValueWarning', ...
                   ['setFilter function expects values between ' ...
                   '0 and 1 - value is being ignored']);
           else
               fprintf(obj.SerialObj,'<L:%d>',weight);
           end
       end
       
       function setDelaySamples(obj, n)
           % Flexy2.DelaySamples(N) introduces an atrificial measurement 
           % delay of N samples of internal sampling frequency. 
           % For value of N = 0, no delay is present. Maximum value of N is
           % 100 samples.
           %
           % see also: .setInternalSamplingFreq (see <a href="matlab:help Flexy2.setInternalSamplingFreq">Flexy2.setInternalSamplingFreq</a>)
           if(n>100)
               warning('FlexyWarning:UnexpectedValueWarning', ...
                   ['setDelaySamples function expects values between ' ...
                   '0 and 100 - value is being ignored']);
           elseif(n<0)
               warning('FlexyWarning:UnexpectedValueWarning', ...
                   ['setDelaySamples function expects values between ' ...
                   '0 and 100 - value is being ignored']);
           else
               fprintf(obj.SerialObj,'<D:%d>',n);
           end
       end
       
       function calibrate(obj)
            % Flexy2.calibrate() performs an output signal calibration 
            % procedure and scales the output to full 0-100 percent range
          	fprintf(obj.SerialObj,'<C:1>');
       end
       
       function out = getBendPerc(obj)
            % Flexy2.getBendPerc() returns the degree of bend of flex
            % resistor in percent
            out = obj.BendPerc;
       end
       
       function out = getUserInputLPerc(obj)
            % Flexy2.getUserInputLPerc() returns the signal from left user input 
            % (potentiometer) in percent
            out = obj.UserInputLPerc;
       end
       
       function out = getUserInputRPerc(obj)
            % Flexy2.getUserInputRPerc() returns the signal from right user input 
            % (potentiometer) in percent
            out = obj.UserInputRPerc;
       end
       
       function out = getTerminalInputPerc(obj)
            % Flexy2.getTerminalInputPerc() returns the voltage level 
            % (in percent of 0-5V) of a signal connected to input terminal AI 
            out = obj.TerminalInputPerc;
       end
       
       function off(obj)
            % Flexy2.off turns off the fan
            obj.setFanSpeedPerc(0);
       end
       

       function connect(obj)
            obj.serialConnect();
            obj.dataFlowOnOff(1);
       end

       function close(obj)
            % Flexy2.close closes active connection
            % This must be done before the class object is deleted or a new one is created.
            obj.serialClose();
       end
       
       function setPort(obj, port)
            obj.ComPort = port;
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
                      pause(4);
                      fprintf(ser,'<V:1>');
                      pause(0.1);
                      message = fscanf(ser,'%s');
                      warning('on','all')
                      [~,ver] = strtok(message,':');
                      obj.Version = ver(2:end-1);
                      obj.ComPort = ports{i};
                      if(~isempty(obj.Version))
                          disp([obj.Version ' found on port ' ports{i}]);
                          fclose(ser);
                          delete(ser);
                          break;
                      end
                      fclose(ser);
                      delete(ser);
                  end
               end
               if(isempty(obj.Version))
                  error('No Flexy2 device found.');
               end
           else
               error(['Specification of com. port is required. ' ...
                   'See <a href="matlab:help Flexy2">help Flexy2</a> ' ...
                   'for more information.'])
           end
       end
           
       function getIncommingMessage(obj)
            % Parsing function for incomming messages
            message = fscanf(obj.SerialObj,'%s');
            [~,data] = strtok(message,':');
            [d1,d234] = strtok(data,',');
            [d2,d34] = strtok(d234,',');
            [d3,d4] = strtok(d34,',');
            obj.BendPerc = str2double(d1(2:end));
            obj.UserInputLPerc = str2double(d2(1:end));
            obj.UserInputRPerc = str2double(d3(1:end));
            obj.TerminalInputPerc = str2double(d4(2:end-1));
            if(obj.VerboseMode)
                disp(message);
            end
            obj.LastIncommingMessage = message;
       end
       
       function initSerialObject(obj, com_port)
            % Initiates serial object
            obj.ComPort = com_port;
            obj.SerialObj = serial(com_port);
            set(obj.SerialObj,'BaudRate', obj.COM_BAUD_RATE);
            set(obj.SerialObj,'Terminator',{'CR/LF',''});
            obj.SerialObj.BytesAvailableFcnMode = 'terminator';
            obj.SerialObj.BytesAvailableFcn = @(~,evt)obj.getIncommingMessage();
       end
        
       function serialConnect(obj)
            % Establishes connection via serial interface
            fopen(obj.SerialObj); % this will reset the MCU, so we need to wait a while
            disp('Waiting for connection ...');
            pause(4);
            if(strcmp(obj.SerialObj.status,'open'))
                obj.SerialStatus = 'Open';
                disp('Connection established.')   
            else
                error('FlexyError:SerialConnectError', ...
                    ['Could not establish the serial connection.\n ' ...
                    '%s port may be missing or used by other program.'], ...
                    obj.ComPort);    
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