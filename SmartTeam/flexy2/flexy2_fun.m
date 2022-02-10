function flexy2_fun(block)

setup(block);

%endfunction

function setup(block)
global lastDelay;
global lastNoise;
global lastWeight;
lastDelay = 0;
lastNoise = 0;
lastWeight = 0;
% Register number of ports
block.NumInputPorts  = 4;
block.NumOutputPorts = 4;

% Setup port properties to be inherited or dynamic
block.SetPreCompInpPortInfoToDynamic;
block.SetPreCompOutPortInfoToDynamic;

% Register parameters
block.NumDialogPrms     = 3;
block.DialogPrmsTunable = {'Nontunable', ...
                           'Nontunable', ...
                           'Nontunable' ...
                          };

block.SampleTimes = [block.DialogPrm(1).Data 0];

block.SimStateCompliance = 'DefaultSimState';

block.RegBlockMethod('SetInputPortSamplingMode',@SetInputPortSamplingMode);
block.RegBlockMethod('PostPropagationSetup',    @DoPostPropSetup);
block.RegBlockMethod('InitializeConditions', @InitializeConditions);
block.RegBlockMethod('Start', @Start);
block.RegBlockMethod('Outputs', @Outputs);     % Required
block.RegBlockMethod('Update', @Update);
block.RegBlockMethod('Derivatives', @Derivatives);
block.RegBlockMethod('Terminate', @Terminate); % Required

%end setup

function SetInputPortSamplingMode(block, idx, fd)
  block.InputPort(idx).SamplingMode = fd;
  block.OutputPort(1).SamplingMode = fd;
  block.OutputPort(2).SamplingMode = fd;
  block.OutputPort(3).SamplingMode = fd;
  block.OutputPort(4).SamplingMode = fd;

function DoPostPropSetup(block)
    if block.SampleTimes(1) == 0
        throw(MSLException(block.BlockHandle,'Dicrete sampling time required'));
    end

function InitializeConditions(block)
    block.OutputPort(1).Data = 0;
    block.OutputPort(2).Data = 0;
    block.OutputPort(3).Data = 0;
    block.OutputPort(4).Data = 0;

%end InitializeConditions

function Start(block)
global flexy2_instance;
    %flexy2_instance = evalin('base','flex');
    flexy2_instance = Flexy2(block.DialogPrm(2).Data);
    pause(4);
    flexy2_instance.setVerboseModeOnOff(0); %debugging
    if(block.DialogPrm(3).Data)
        flexy2_instance.calibrate();
        disp('calibrating Flexy');
    end
    flexy2_instance.setInternalSamplingFreq(round(1/block.DialogPrm(1).Data));
    if(block.DialogPrm(3).Data)
        pause(10);
        disp('please wait ...');
    end
%endfunction

function Outputs(block)
global flexy2_instance;
global lastDelay;
global lastNoise;
global lastWeight;
last_delay = lastDelay;
delay = block.InputPort(2).Data;
if(last_delay~=delay)
    flexy2_instance.setDelaySamples(delay);
end
lastDelay = delay;
%last_noise = lastNoise;
%noise = block.InputPort(3).Data;
%if(last_noise~=noise)
%    flexy2_instance.setArtificialNoise(noise);
%end
%lastNoise = noise;
last_weight = lastWeight;
weight = block.InputPort(4).Data;
if(last_weight~=weight)
    flexy2_instance.setFilter(weight);
end
lastWeight = weight;
flexy2_instance.setFanSpeedPerc(block.InputPort(1).Data);
block.OutputPort(1).Data = flexy2_instance.getBendPerc();
block.OutputPort(2).Data = flexy2_instance.getUserInputLPerc();
block.OutputPort(3).Data = flexy2_instance.getUserInputRPerc();
block.OutputPort(4).Data = flexy2_instance.getTerminalInputPerc();
%end Outputs

function Update(block)

%end Update

function Derivatives(block)

%end Derivatives

function Terminate(block)
    global flexy2_instance;
    flexy2_instance.off();
    flexy2_instance.close();
    flexy2_instance.delete();
    
 %end Terminate

