
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% NN_LOAD
%
% File for detecting a door position based on the neural network. M-file
% consists of a Python function that provides binary door position data
% (1 -> open, 0 -> closed) predicted by a change in humidity and tepereture
% values as an output parameter. It requires no input parameters.
%
% List of output variables
%   pos           - door opening position - neural network data
%
% List of local variables
%   bme_vals      - BME sensor humidity data set (of length 'samples')
%   bot_vals      - bottom greenhouse temperature data set (of length
%                   'samples')
%   data_bme      - N-last humidity data from BME sensor
%   data_bot      - N-last bottom greenhouse temperature data
%   data_dht      - N-last humidity data from DHT sensor
%   data_top      - N-last top greenhouse temperature data
%   dht_vals      - DHT sensor humidity data set (of length 'samples')
%   inputs        - input data for Python neural network
%   options       - settings to connect to the Arduino API Cloud
%   samples       - the smallest necessary length of the time series of
%                   data for detection
%   time_vals     - time data set (of length 'samples')
%   top_vals      - top greenhouse temperature data set (of length
%                   'samples')
%
% List of used functions
%   read_data     - load and read data from Arduino API Cloud
%   reconnect     - connects to the Arduino API Cloud
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pos = nn_load

% Load input data
options = reconnect;
data_bme = read_data('sensor','_bmmeH','bmmeH',options);
data_dht = read_data('sensor','_dhtH','dhtH',options);
data_top = read_data('sensor','_tempT','tempT',options);
data_bot = read_data('sensor','_tempB','tempB',options);

% Filter input data
samples = 8;
time_vals = {data_bme.data.time}';
time_vals = flip(time_vals(1:samples));
for i = 1:samples
    time_vals{i} = string(datetime(strrep(strrep(time_vals{i},'T',' '), ...
        'Z',''),'InputFormat','yyyy-MM-dd HH:mm:ss')+hours(1));
end
bme_vals = {data_bme.data.value}';
bme_vals = flip(bme_vals(1:samples));
dht_vals = {data_dht.data.value}';
dht_vals = flip(dht_vals(1:samples));
top_vals = {data_top.data.value}';
top_vals = flip(top_vals(1:samples));
bot_vals = {data_bot.data.value}';
bot_vals = flip(bot_vals(1:samples));
inputs = cell2mat([bme_vals,dht_vals,top_vals,bot_vals]);

% Load Python script
pos = pyrunfile("SmartSensor.py","output",inputs = inputs);
pos = sum(logical(pos));

end
