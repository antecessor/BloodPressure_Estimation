function Feature=PPG_Processing(Signal,Fs,view)
timeDistance=.20; %ms
Distance=timeDistance*Fs;
%% Normalize
Signal=Signal/max(Signal);
%% Find Systolic Peak
[pks_sys,locs_sys]=findpeaks(Signal,'MinPeakHeight',.1,'MinPeakDistance',Distance);
%% Minimum PPG for finding PATf
[pks_sys_min,locs_sys_min]=findpeaks(-Signal,'MinPeakHeight',.1,'MinPeakDistance',Distance);
pks_sys_min=-pks_sys_min;
%% Find Mean F and systolic for PATd
Dist=[];
Subset=[];
for i=1:numel(locs_sys)
    for j=1:numel(locs_sys_min)
       Dist(i,j)=abs(locs_sys(i)-locs_sys_min(j)); 
    end
end

[a,b]=size(Dist);
if a>=b
  mD=min(Dist);
  for i=1:numel(mD)
    ind= Dist(:,i)==mD(i);
    Subset=[Subset; locs_sys(ind) locs_sys_min(i)];
  end
else
     mD=min(Dist');
  for i=1:numel(mD)
    ind= Dist(i,:)==mD(i);
    Subset=[Subset;locs_sys(i)  locs_sys_min(ind)];
  end
    
end
if (numel(unique(Subset(:,1)))~=numel(Subset(:,1))) 
    [~,a]=unique(Subset(:,1));
    Subset=Subset(a,:);
elseif  (numel(unique(Subset(:,2)))~=numel(Subset(:,2))) 
     [~,a]=unique(Subset(:,2));
    Subset=Subset(a,:);
end
Mean_F=round(mean(Subset'));
%% Diastolyc & Inftions point
[DiastolicInd,InfectionInd]=DiastolicPoint_InfectionPoint(Signal,Subset,pks_sys,Fs);

%%
Feature.Mean_F=Mean_F';
Feature.Systolic=Subset(:,1);
Feature.Systolic_End=Subset(:,2);
Feature.Diastolic=DiastolicInd';
Feature.Infection=InfectionInd';
%% 
if view==1
figure(5)
clf
plot(Subset(:,1),Signal(Subset(:,1)),'o')
hold on
plot(Subset(:,2),Signal(Subset(:,2)),'o')
plot(Mean_F,Signal(Mean_F),'*')
plot(Signal)
plot(DiastolicInd,Signal(DiastolicInd),'o')
pause(.001)
end
end