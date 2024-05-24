function varargout = stepfan(sysobj, opt)
%STEPFAN Step response of real system fan.
%
%  [Y, T, U] = STEPFAN(SYS) returns the step response Y of the real system fan.
%  The time vector T is expressed as the datestr and the time step and final
%  time are chosen automatically. U represents the step change in time.
%  
%  [Y, T, U] = STEPFAN(SYS, OPTIONS) specifies additional options such as the
%    final time, step amplitude, input offset, sampling timeor plotting. Options
%    are represented as the X, Y pairs. Currently supported options are:
%       X               |Y          
%       'tFinal'        |int16      |
%       'StepAmpPerc'   |double     |
%       'NumSteps'      |int16      |
%       'InputOffset'   |double     |
%       'Ts'            |double     |
%       'Plot'          |logical    |
%       'LineSpec       |string     |
%
    arguments
        sysobj
        opt.tFinal (1,1) int16 {mustBeNumeric,mustBeReal} = 5
        opt.StepAmpPerc (1,:) double {mustBeNumeric,mustBeReal} = 50
        opt.NumSteps    (1,1) int16 {mustBeNumeric,mustBeReal} = 1
        opt.InputOffset (1,1) double {mustBeNumeric,mustBeReal} = 0
        opt.Ts (1,1) double {mustBeNumeric,mustBeReal} = 0.05
        opt.Plot logical = true
        opt.LineSpec string = 'b'
    end
    
    pause(2)
    
    if opt.StepAmpPerc < 1 
        opt.StepAmpPerc = opt.StepAmpPerc * 100; 
    else
        % Saturate to range from 0% to 100%
        opt.StepAmpPerc = min(max(opt.StepAmpPerc, 0), 100);
    end
    
    if opt.InputOffset ~= 0
        % Perform step changes around steady-state value defined as InputOffset
        %steps = (rand(1,opt.NumSteps)*2-1)*opt.StepAmpPerc+opt.InputOffset;
        steps = (randi([-opt.StepAmpPerc opt.StepAmpPerc],1,opt.NumSteps)) ...
                +opt.InputOffset;
    else
        % Perform step changes from 0% to 100%
        steps = (rand(1,opt.NumSteps))*100;
    end

    steps = min(max(steps, 0), 100);

    % Initialization of workspace
    measurements_per_speed = opt.tFinal/opt.Ts;
    n_observations = measurements_per_speed*length(opt.StepAmpPerc);
    
    % Initialization of variables
    %t = strings(n_observations, 1); % for processes with very slow dynamics
    t = zeros(n_observations, 1);
    u = zeros(n_observations, 1);
    y = zeros(n_observations, 1);
    
    % Get observation before change on input
    table_row = 1;
    %t(table_row) = convertCharsToStrings(datestr(now));
    t(table_row) = 0;
    u(table_row) = opt.InputOffset;
    y(table_row) = getBendPerc(sysobj);
    
    tic
    for amplitude = steps
        % Sets motor speed according to loop setting
        setFanSpeedPerc(sysobj, amplitude) 
        % Sets number of measurements for each motor speed
        for num_measurements = 1:measurements_per_speed
            table_row = table_row+1;
            tic
            % Apend table with currently measured data
            %t(table_row) = convertCharsToStrings(datestr(now));
            t(table_row) = opt.Ts*(table_row-1); 
            u(table_row) = amplitude;
            y(table_row) = getBendPerc(sysobj);
            % Sampling period
            pause(opt.Ts-toc)
        end  
    end   
    toc

    % Return motor speed to where it was before step
    setFanSpeedPerc(sysobj, opt.InputOffset)
    pause(2)

    if opt.Plot
        f = figure;
        f.Position = [100 100 960 540];
        subplot(2,1,1)
        plot(t, y, opt.LineSpec)
        grid on
        ylim([-5, 105])
        ylabel('Bend [%]')
        title('Response of the system to input change', 'FontWeight','Normal')
        subplot(2,1,2)
        plot(t, u, opt.LineSpec)
        grid on
        %xlabel('No. Samples')
        xlabel('Time [s]')
        ylim([-5, 105])
        ylabel('Input Fan Speed [%]')
    end
    
    data.t = t;
    data.u = u;
    data.y = y;
    fns = fieldnames(data);

    for k = 1:nargout
        if nargout == 1
        varargout{k} = data;
        else
        varargout{k} = data.(fns{k});
        end
    end

end