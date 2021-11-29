function [SBP,DBP]=FindDBP_FindSBP(ABP)
%% SBP
Distance=50;
[pks,locs] = findpeaks(ABP,'MinPeakHeight',80,'MinPeakDistance',Distance);
x= pks>180;
locs(x)=[];
try
    SBP=median(pks);
catch
    SBP=[];
end
%% DBP
Distance=50;
[pks,locs] = findpeaks(-ABP,'MinPeakHeight',-130,'MinPeakDistance',Distance);
pks=-pks;
x= pks<60;
locs(x)=[];
try
    DBP=median(pks);
catch
    DBP=[];
end
end