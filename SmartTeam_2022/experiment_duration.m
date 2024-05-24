%time_sample = [heat.data.time]; %time sample from saved data 
time_sample = [light.data.time];

Nt = length(time_sample) / 20   %divides data
for k = 1 : Nt
    t{k} = time_sample((k-1)*20+1 : k*20);
end

for k = 1 : Nt                  
   year{k} =  t{k}(1:4);
   month{k} =  t{k}(6:7)
   day{k} =  t{k}(9:10);
   hour{k} =  t{k}(12:13)
   minute{k} =  t{k}(15:16);
   second{k} = t{k}(18:19);
end

for k = 1 : Nt       %rewrites data into string 
   t_matlab{k} = datestr([ str2num(year{k}), str2num(month{k}), str2num(day{k}), str2num(hour{k}), str2num(minute{k}), str2num(second{k}) ])
end

for k = 1 : Nt-1     %
    durat(k,1) = minutes( days(str2num(day{k+1}) - str2num(day{k})) + ...
        hours(str2num(hour{k+1}) - str2num(hour{k})) + ...
        minutes(str2num(minute{k+1}) - str2num(minute{k})) + ...
        seconds(str2num(second{k+1}) - str2num(second{k})) )
end


