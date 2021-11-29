function [R_i,heart_rate]=ECG_R_Dectect(Signal,Fs,view)
timeDistance=.30; %ms
Distance=timeDistance*Fs;
time_scale = length(Signal)/Fs; % total time;
%% Normalize
Signal=Signal/max(Signal);
[R_a,R_i]=findpeaks(Signal,'MinPeakHeight',.2,'MinPeakDistance',Distance);
if view==1
    figure(333)
    clf
    plot(Signal)
    hold on
    plot(R_i,R_a,'o');
    pause(.001)
end
R_R = diff(R_i); % calculate the distance between each R wave
heart_rate=length(R_i)/(time_scale/60); % calculate heart rate
end