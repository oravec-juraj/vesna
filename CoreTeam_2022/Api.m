client_id = "Ij7686MXMIXCS4JyGJTe5nyQNQM6w7R9";
client_secret = "BWbnmLopN6lUDPncNZ5zDmAYvHk81TQUbHWFACt9FwysSfqiBgQYhpkVeIYLtYDQ";
url = "https://api2.arduino.cc/iot/v1/clients/token";
headerFields = {'Content-type' 'application/x-www-form-urlencoded';'charset' 'UTF-8'};
options = weboptions('HeaderFields', headerFields);


response = webwrite(url,...
'client_id', client_id,...
'client_secret', client_secret,...
'grant_type','client_credentials',...
'audience','https://api2.arduino.cc/iot',...
options);


access_token = response.access_token;
% save access token for future calls
headerFields = {'Authorization', ['Bearer ', access_token]};
options = weboptions('HeaderFields', headerFields, 'ContentType','json','MediaType', 'auto');

%% read data series light -- struktura serie hodnoty zo svetla, stlpec 1 cas, stlpec 2 hodnota 
options.RequestMethod = 'auto'
%?from='2022-03-30T11:00:00Z'&interval=56&to='2022-03-30T11:30:00Z'
tserie = webread("https://api2.arduino.cc/iot/v2/things/{95e254c8-7421-4d0e-bcb6-4b6991c87b4f}/properties/{d6653286-1d51-49d0-83b9-0dd6bf6b54fe}/timeseries?from=2022-03-29T11:00:00Z&interval=1&to=2022-03-29T11:29:00Z",options)
%% read data fans
options.RequestMethod = 'auto'
fans_hodn = webread("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{0c8a7441-7894-4d36-b4ec-7df63dfebd2a}",options)

%% write data Fans -- poslanie hodnotu ventilatora
propertyValue = struct('value',130)
options.RequestMethod = 'put'
webwrite("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{0c8a7441-7894-4d36-b4ec-7df63dfebd2a}/publish",propertyValue,options)