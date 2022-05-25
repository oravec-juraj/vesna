client_id = "Ij7686MXMIXCS4JyGJTe5nyQNQM6w7R9";
client_secret = "BWbnmLopN6lUDPncNZ5zDmAYvHk81TQUbHWFACt9FwysSfqiBgQYhpkVeIYLtYDQ";
url = "https://api2.arduino.cc/iot/v1/clients/token";
headerFields = {'Content-type' 'application/x-www-form-urlencoded';'charset' 'UTF-8'};
options = weboptions('HeaderFields', headerFields);


response = webwrite(url,'client_id', client_id,'client_secret', client_secret,'grant_type','client_credentials','audience','https://api2.arduino.cc/iot',options);



%data = [...
% '&client_id=', client_id,...
% '&client_secret=', client_secret
% ];
%response = webwrite(url,data);
access_token = response.access_token;
% save access token for future calls
%propertyValue = {'propertyValue', ['value', 20]};
headerFields = {'Authorization', ['Bearer ', access_token]};
%options = weboptions('HeaderFields', propertyValue);
options = weboptions('HeaderFields', headerFields, 'ContentType','json','MediaType', 'auto');
% 'MediaType', 'application/json'
