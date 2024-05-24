reconnect
options.RequestMethod = 'auto'
%displays data from light sensor
light = webread("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{d6653286-1d51-49d0-83b9-0dd6bf6b54fe}/timeseries?from=2022-05-23T16:00:00Z&interval=1800&to=2022-05-24T16:00:00Z",options)
%displays data from light controller 
%light = webread("https://api2.arduino.cc/iot/v2/things/{aa0190a8-9312-4a17-8842-25a1dd483860}/properties/{128d9d60-0c2f-4a58-a3e4-fb833e10bf81}/timeseries?from=2022-05-23T16:00:00Z&interval=1800&to=2022-05-24T16:00:00Z",options)

intens_light_val = [light.data.value]';
%%
experiment_duration
Nnstep = length( durat );
mym_values = [light.data.value]';
t11m = [light.data.time]';
li = [];
for k = 1 : Nnstep
   li = [ li; mym_values(k) * ones( durat(k), 1 ) ];
end



%%
t_date_22 = datetime(2022,5,24,17,[0:1409],0);
figure()
plot(t_date_22,li)
hold on
grid on
box on



