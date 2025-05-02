function f2p(name, varargin)
%% Plot to Picture - f2p: figure to picture version 2.8
%
%   Generates picture with extension of users choice from a plot/figure.
%
%   General usage: f2p(name, varagin)
%
%   mandatory argument:
%       name: name of the figure
%
%   optional argument pairs
%       Extension: if extension is provided, then the function will
%                  save the figure in the current folder with the name
%                  specified by the user. Allowed extensions are:
%                  {'pdf', 'bmp', 'jpg', 'png', 'eps', 'tikz'}
%       Path: path to the folder where the figure is to be saved, if
%             ommited, the picture will be saved in the current folder
%       XLim: limits on x-axis, a vector of two elements, if axis style is
%       set to 'log', the limits indicate the powers of 10
%       YLim: limits on y-axis, a vector of two elements, if axis style is
%       set to 'log', the limits indicate the powers of 10
%       Xtol: inreases the distance from the vertical box-lines
%             by a given fraction, from the interval [0, 1]. Default is 0,
%             Not aplicable in log-scale
%       Ytol: inreases the distance from the horizontal box-lines
%             by a given fraction, from the interval [0, 1]. Default is 0.1
%             Not aplicable in log-scale
%       Xscale: define scale for the axis {'linear'|'log'}, default: linear
%       Yscale: define scale for the axis {'linear'|'log'}, default: linear
%       Xsplit: number of ticks/splits on the x-axis
%       Ysplit: number of ticks/splits on the y-axis
%       dpi: set the dpi for raster exports; default is 300
%       LineWidth: sets linewidth for all lines within the figure, this
%                  ignores user defined linewidths or markersizes
%       grid: {true|false} default is true
%       box: {true|false} default is true
%       XMinorGrid: minor grid on the x-axis
%       YMinorGrid: minor grid on the y-axis
%       NoLabels: removes x, y, and z labels
%       PaperSize: dimensions of the resulting picture, aplicable in all
%                  except TikZ. Default is [27.94, 21.59]cm or [11, 8.5]",
%                  which is default Matlab dimension of the figure as
%                  seen on the screen.
%       Save: {true|false}, default true, if false, f2p() only formats the
%             figure, but it will not save it
%

%% Body of the main fuction
if ischar(name)
    set(gcf, 'name', name, 'NumberTitle', 'off')
else
    error('Input must be single string or structure')
end

%% get current figure data and defaults
clear f
f = gcf;
axes  = f.Children;
lines = axes.Children;
try
    Xsplits = length(f.CurrentAxes.XTick)-1;
    Ysplits = length(f.CurrentAxes.YTick)-1;
    xlim = f.CurrentAxes.XLim;
    ylim = f.CurrentAxes.YLim;
catch
    Xsplits = 0;
    Ysplits = 0;
    xlim = [0, 0];
    ylim = [0, 0];
end

%% parse inputs
p = inputParser;
ext = {'pdf', 'eps', 'tikz', 'png', 'bmp', 'jpg'};

TikzOptions = [ 'ylabel style={font=\scriptsize},',...
    'xlabel style={font=\scriptsize},',...
    'scaled y ticks = base 10:0,',...
    'scaled x ticks = base 10:0,',...
    'xticklabel style={font=\scriptsize, /pgf/number format/.cd,fixed,fixed zerofill,precision=2,1000 sep={},/tikz/.cd},'...
    'yticklabel style={font=\scriptsize, /pgf/number format/.cd,fixed,fixed zerofill,precision=2,1000 sep={},/tikz/.cd},'...
    'legend style={font=\scriptsize}'];


%     'scaled y ticks = true,',....
%     'scaled x ticks = true,',....
%     /pgf/number format/.cd, 1000 sep={}

p.addParameter('XLim', xlim, @isvector);
p.addParameter('YLim', ylim, @isvector);
p.addParameter('Xtol', 0, @isnumeric);
p.addParameter('Ytol', 0.1, @isnumeric);
p.addParameter('Xscale', 'linear', @ischar);
p.addParameter('Yscale', 'linear', @ischar);
% p.addParameter('XtickNumber', xt, @isnumeric);
% p.addParameter('YtickNumber', yt, @isnumeric);
p.addParameter('Xsplit', Xsplits, @isnumeric);
p.addParameter('Ysplit', Ysplits, @isnumeric);
p.addParameter('LineWidth', 1, @isnumeric);
p.addParameter('grid', true, @islogical);
p.addParameter('XMinorGrid', false, @islogical);
p.addParameter('YMinorGrid', false, @islogical);
p.addParameter('box', true, @islogical);
p.addParameter('Extension', 'empty', ...
    @(q) any(validatestring(q, ext)));
p.addParameter('Path', '.', @ischar);
p.addParameter('PaperSize', [11 8.5]*2.54, @isvector);
p.addParameter('NoLabels', false, @islogical);
p.addParameter('Save', true, @islogical);
p.addParameter('dpi', 300, @isnumeric);
p.addParameter('TikZOptions', TikzOptions, @ischar);
p.addParameter('ignore', false, @islogical);

% pars inputs
parse(p, varargin{:});
r = p.Results;

% parsize: inches to cm buy default
% r.PaperSize = r.PaperSize/2.54;

%% grid on/off
if ~r.ignore
    if r.grid
        grid on
    else
        grid off
    end

    if r.YMinorGrid
        set(f.CurrentAxes, 'YMinorGrid', 'on')
    else
        set(f.CurrentAxes, 'YMinorGrid', 'off')
    end

    if r.XMinorGrid
        set(f.CurrentAxes, 'XMinorGrid', 'on')
    else
        set(f.CurrentAxes, 'XMinorGrid', 'off')
    end
end
%% box on/off
if ~r.ignore
    if r.box
        box on
    else
        box off
    end
end
%% set limits
if numel(axis)/2 == 3
    warning('Automatic limits handling disabled for 3D plots, will be available in v3.0.')
end
if ~r.ignore && (numel(axis)/2 == 2)
    % checks limits and set a new limits if aplicable
    xdmin = inf;
    xdmax = -inf;
    for k = 1:1:length(f.CurrentAxes.Children)
        if ~(strcmp(f.CurrentAxes.Children(k).Type, 'patch') || strcmp(f.CurrentAxes.Children(k).Type, 'text') || strcmp(f.CurrentAxes.Children(k).Type, 'surface'))
            xdmin = min([xdmin, min(f.CurrentAxes.Children(k).XData)]);
            xdmax = max([xdmax, max(f.CurrentAxes.Children(k).XData)]);
        end
    end
    xdatamin = floor(log10(xdmin));
    xdatamax = ceil(log10(xdmax));
    if strcmp(r.Xscale, 'log')
        set(f.CurrentAxes, 'Xlim', [10^(xdatamin), 10^(xdatamax)]);
    end
    ydmin = inf;
    ydmax = -inf;
    for k = 1:1:length(f.CurrentAxes.Children)
        if ~(strcmp(f.CurrentAxes.Children(k).Type, 'patch') || strcmp(f.CurrentAxes.Children(k).Type, 'text') || strcmp(f.CurrentAxes.Children(k).Type, 'surface'))
            ydmin = min([ydmin, min(f.CurrentAxes.Children(k).YData)]);
            ydmax = max([ydmax, max(f.CurrentAxes.Children(k).YData)]);
        end
    end
    ydmin = floor(log10(ydmin));
    ydmax = ceil(log10(ydmax));
    if strcmp(r.Yscale, 'log')
        set(f.CurrentAxes, 'Ylim', [10^(ydmin), 10^(ydmax)]);
    end

    if ( (r.XLim(1) ~= f.CurrentAxes.XLim(1)) || ...
            (r.XLim(2) ~= f.CurrentAxes.XLim(2)) )
        set(f.CurrentAxes, 'XLim', r.XLim);
        if strcmp(r.Xscale, 'log')
            set(f.CurrentAxes, 'Xlim', [10^(r.XLim(1)), 10^(r.XLim(2))]);
        end
    end

    if ( (r.YLim(1) ~= f.CurrentAxes.YLim(1)) || ...
            (r.YLim(2) ~= f.CurrentAxes.YLim(2)) )
        set(f.CurrentAxes, 'YLim', r.YLim);
        set(f.CurrentAxes, 'XLim', r.XLim);
        if strcmp(r.Yscale, 'log')
            set(f.CurrentAxes, 'Ylim', [10^(r.YLim(1)), 10^(r.YLim(2))]);
        end
    end

    % obtain limits and calculate shrinked figure space and set values
    limits = obtain_limits();
    if strcmp(r.Xscale, 'linear')
        limits.x.lim_new(1) = limits.x.lim(1) - limits.x.range*r.Xtol;
        limits.x.lim_new(2) = limits.x.lim(2) + limits.x.range*r.Xtol;
        set(f.CurrentAxes, 'Xlim', limits.x.lim_new);
        % calculate ticks
        xstep = limits.x.range/r.Xsplit;
        limits.x.tick = limits.x.lim(1):xstep:limits.x.lim(2);
        set(f.CurrentAxes, 'Xtick', limits.x.tick);
    elseif strcmp(r.Xscale, 'log')
        xlimNew = f.CurrentAxes.XLim;
        xlimLogMin = floor(log10(xlimNew(1)));
        xlimLogMax = floor(log10(xlimNew(2)));
        xlimLogLength = xlimLogMax - xlimLogMin;
        if xlimLogLength > r.Xsplit
            xstep = floor(xlimLogLength/r.Xsplit);
        else
            xstep = 1;
        end
        xtikcs = 10.^(xlimLogMin:xstep:xlimLogMax);
        xlimNew(1) = 10^(log10(xlimNew(1)) - r.Xtol);
        xlimNew(2) = 10^(log10(xlimNew(2)) + r.Xtol);
        set(f.CurrentAxes, 'Xlim', xlimNew)
        set(f.CurrentAxes, 'Xtick', xtikcs);
        set(f.CurrentAxes, 'Xscale', 'log')
    end
    if strcmp(r.Yscale, 'linear')
        limits.y.lim_new(1) = limits.y.lim(1) - limits.y.range*r.Ytol;
        limits.y.lim_new(2) = limits.y.lim(2) + limits.y.range*r.Ytol;
        set(f.CurrentAxes, 'Ylim', limits.y.lim_new);
        ystep = limits.y.range/r.Ysplit;
        limits.y.tick = limits.y.lim(1):ystep:limits.y.lim(2);
        set(f.CurrentAxes, 'Ytick', limits.y.tick);
    elseif strcmp(r.Yscale, 'log')
        ylimNew = f.CurrentAxes.YLim;

        ylimLogMin = floor(log10(ylimNew(1)));
        ylimLogMax = floor(log10(ylimNew(2)));
        ylimLogLength = ylimLogMax - ylimLogMin;
        if ylimLogLength > r.Ysplit
            ystep = floor(ylimLogLength/r.Ysplit);
        else
            ystep = 1;
        end
        ytikcs = 10.^(ylimLogMin:ystep:ylimLogMax);

        ylimNew(1) = 10^(log10(ylimNew(1)) - r.Ytol);
        ylimNew(2) = 10^(log10(ylimNew(2)) + r.Ytol);
        set(f.CurrentAxes, 'Ylim', ylimNew)
        set(f.CurrentAxes, 'Ytick', ytikcs);
        set(f.CurrentAxes, 'Yscale', 'log')


    end
end
%% sets linewidth
if ~r.ignore
    if r.LineWidth > 0
        for k = 1:1:length(f.CurrentAxes.Children)
            if strcmp(f.CurrentAxes.Children(k).Type, 'line') ||...
                    strcmp(f.CurrentAxes.Children(k).Type, 'stair')
                set(f.CurrentAxes.Children(k), 'LineWidth', r.LineWidth);
            end
        end

    end

    if (r.NoLabels == true)
        set(gca, 'Xticklabel', {}, 'Yticklabel', {})
    end
end
%% save the figure
ext = r.Extension;

set(f, 'PaperUnits', 'centimeters');
set(f, 'Units', 'centimeters');
set(f, 'PaperType', '<custom>');
set(f, 'PaperSize', r.PaperSize);
set(f, 'PaperPosition', [0, 0, r.PaperSize(1), r.PaperSize(2)]);

if r.Save && strcmp(ext, 'empty')

elseif r.Save && ~strcmp(ext, 'empty')
    saveNamePath = [r.Path, '/', name];

    if strcmp(ext, 'png')
        driver = '-dpng';
        get(f)
        print(f, driver, ['-r', num2str(r.dpi)], saveNamePath)
    end

    if strcmp(ext, 'bmp')
        driver = '-dbmp';
        print(f, driver, ['-r', num2str(r.dpi)], saveNamePath)
    end

    if strcmp(ext, 'jpg')
        driver = '-djpeg';
        print(f, driver, ['-r', num2str(r.dpi)], saveNamePath)
    end

    if strcmp(ext, 'eps')
        driver = '-depsc2';
        print(f, driver, ['-r', num2str(r.dpi)], saveNamePath)
    end

    if strcmp(ext, 'pdf')
        driver = '-dpdf';
        set(f, 'PaperUnits', 'centimeters');
        set(f, 'Units', 'centimeters');
        set(f, 'PaperType', '<custom>');
        set(f, 'PaperSize', r.PaperSize);
        set(f, 'PaperPositionMode', 'manual');
        set(f, 'PaperPosition', [0, 0, r.PaperSize(1), r.PaperSize(2)]);
        print(f, driver, ['-r', num2str(r.dpi)], saveNamePath)
    end

    if strcmp(ext, 'tikz')
        if exist('matlab2tikz', 'file') == 2
            saveNamePathTikz = [r.Path, '/', name, '.tikz'];
            matlab2tikz(saveNamePathTikz, 'height', '\figureheight',...
                'width', '\figurewidth', 'parseStrings', false,...
                'showInfo', false, 'floatFormat', '%.4g', ...
                'extraaxisoptions', r.TikZOptions, ...
                'colormap', colormap);
        else
            error('External function/toolbox "matlab2tikz" required.')
        end
    end

    s = dir([saveNamePath, '.', ext]);
    file_size = ceil(s.bytes)/1000;
    fprintf(['Figure "', name, '.', ...
        r.Extension, '" of size ', num2str(file_size), ' kB, saved.\n'])

    if (strcmp(ext, 'tikz')) && (file_size > 30)
        fprintf('\n')
        fprintf('!! TikZ files larger than 30kB can cause compilation issues. Try to reduce the number of points in the figure to decrease the filesize.')
        fprintf('\n')
    end
elseif ~r.Save
    %     warning('')
end


%% supporting functions
    function limits = obtain_limits
        limits.x.lim = get(f.CurrentAxes, 'Xlim');
        limits.y.lim = get(f.CurrentAxes, 'Ylim');
        [~, el] = view;
        if el ~= 90
            limits.z.lim = get(f.CurrentAxes, 'ZLim');
            limits.z.range = abs(limits.z.lim(2) - limits.z.lim(1));
        end
        limits.x.range = abs(limits.x.lim(2) - limits.x.lim(1));
        limits.y.range = abs(limits.y.lim(2) - limits.y.lim(1));
    end

end